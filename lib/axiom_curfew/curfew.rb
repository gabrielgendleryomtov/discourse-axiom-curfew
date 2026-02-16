# frozen_string_literal: true

module ::AxiomCurfew
  module Curfew
    TIME_REGEX = /\A((?:[01]\d|2[0-3]):[0-5]\d|24:00)\z/

    def self.active_now?
      return false unless SiteSetting.axiom_curfew_enabled

      tz = timezone
      now = Time.now.in_time_zone(tz)

      minutes = now.hour * 60 + now.min
      schedule = schedule_for(now)

      start_min = parse_time_to_minutes(schedule[:start])
      end_min   = parse_time_to_minutes(schedule[:end])

      return false if start_min.nil? || end_min.nil?

      in_window?(minutes, start_min, end_min)
    rescue => e
      Rails.logger.warn("[axiom-curfew] error computing active_now?: #{e.class} #{e.message}")
      false
    end

    def self.timezone
      tz = SiteSetting.axiom_curfew_timezone.to_s.strip
      tz = "Europe/London" if tz.empty?
      tz
    end

    DAY_NAMES = {
      0 => "sunday",
      1 => "monday",
      2 => "tuesday",
      3 => "wednesday",
      4 => "thursday",
      5 => "friday",
      6 => "saturday"
    }.freeze

    def self.schedule_for(time)
      # time is already in the plugin timezone
      day_name = DAY_NAMES[time.wday]
      {
        start: SiteSetting.public_send("axiom_curfew_#{day_name}_start"),
        end: SiteSetting.public_send("axiom_curfew_#{day_name}_end")
      }
    end

    def self.parse_time_to_minutes(str)
      s = str.to_s.strip
      return nil if s.empty?
      return 1440 if s == "24:00" # not necessary for correct behaviour at the moment but safety in case regex changes
      return nil unless TIME_REGEX.match?(s)

      h, m = s.split(":").map(&:to_i)
      (h * 60) + m
    end

    # Handles both same-day and overnight windows.
    # Example overnight: start=21:00 (1260), end=07:00 (420)
    def self.in_window?(current, start_min, end_min)
      return false if start_min == end_min # start=end disables curfew for that schedule
      
      if start_min < end_min
        # Same-day window
        current >= start_min && current < end_min
      else
        # Overnight window across midnight
        current >= start_min || current < end_min
      end
    end

    # same across two plugins -- consider refactoring

    def self.group_ids_from_setting(setting_value)
      setting_value
        .to_s
        .split("|")
        .map(&:to_i)
        .reject(&:zero?)
        .uniq
    end

    def self.user_in_groups?(user, group_ids)
      return false if user.blank?
      return false if group_ids.blank?

      GroupUser.where(user_id: user.id, group_id: group_ids).exists?
    end

    # end of repeated code

    def self.curfew_group_ids
      group_ids_from_setting(SiteSetting.axiom_curfew_groups)
    end

    def self.user_in_curfew_group?(user)
      return false if user.blank?
      return false if user.staff? # policy decision lives here
      user_in_groups?(user, curfew_group_ids)
    end

    def self.block_posting_for?(user)
      user_in_curfew_group?(user) && active_now?
    end

    def self.user_message
      SiteSetting.axiom_curfew_message.to_s.strip.presence ||
        "Posting is closed during curfew hours. You can still read and return later."
    end
  end
end