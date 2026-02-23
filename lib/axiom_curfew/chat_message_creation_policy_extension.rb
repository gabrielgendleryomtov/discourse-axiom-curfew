# frozen_string_literal: true

module ::AxiomCurfew
  module ChatMessageCreationPolicyExtension
    def call
      return false if curfew_blocks_posting?
      super
    end

    def reason
      return ::AxiomCurfew::Curfew.user_message if curfew_blocks_posting?
      super
    end

    private

    def curfew_blocks_posting?
      ::AxiomCurfew::Curfew.block_posting_for?(guardian&.user)
    end
  end
end
