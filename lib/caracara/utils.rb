#
module Caracara
  module Utils
    # Merge the options in an intelligent way
    def self.merge(a, b)
      a.merge(b) do |key, oldval, newval|
        # Return if both of the values are Hash instances
        next merge(oldval, newval) if oldval.is_a?(Hash) && newval.is_a?(Hash)

        # Return the value
        newval
      end
    end
  end
end
