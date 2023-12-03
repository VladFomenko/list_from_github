# frozen_string_literal: true

module Validatable
  extend ActiveSupport::Concern

  PAGE_SIZE = 16
  ISNT_SET_NAME_USER = 'The name is not set'
end
