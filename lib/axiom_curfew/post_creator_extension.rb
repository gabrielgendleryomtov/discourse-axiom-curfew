# frozen_string_literal: true

module ::AxiomCurfew
  module PostCreatorExtension
    def create
      if ::AxiomCurfew::Curfew.block_posting_for?(@user)
        raise Discourse::InvalidAccess.new(::AxiomCurfew::Curfew.user_message)
      end
      super
    end
  end
end