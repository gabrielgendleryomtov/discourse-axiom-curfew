# frozen_string_literal: true

# name: axiom-curfew
# about: Applies a posting curfew for specified user groups (read-only access remains)
# version: 0.1.0
# authors: Axiom Maths / Gabriel Gendler Yom-Tov
# url: https://axiommaths.com

enabled_site_setting :axiom_curfew_enabled

# register_asset "stylesheets/axiom_curfew.scss"

after_initialize do
  Rails.logger.warn("[axiom-curfew] plugin after_initialize ran")

  require_relative "lib/axiom_curfew/curfew"
  require_relative "lib/axiom_curfew/guardian_extension"
  require_relative "lib/axiom_curfew/post_creator_extension"

  PostCreator.prepend(::AxiomCurfew::PostCreatorExtension)
  Guardian.prepend(::AxiomCurfew::GuardianExtension)
end