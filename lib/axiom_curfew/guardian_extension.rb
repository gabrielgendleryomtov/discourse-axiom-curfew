# frozen_string_literal: true

module ::AxiomCurfew
  module GuardianExtension
    def can_create_topic?(parent)
      return false if curfew_blocks_posting?
      super
    end

    def can_create_post?(topic)
      return false if curfew_blocks_posting?
      super
    end

    private

    def curfew_blocks_posting?
      ::AxiomCurfew::Curfew.block_posting_for?(user)
    end
  end
end
