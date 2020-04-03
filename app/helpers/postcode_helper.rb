require "uk_postcode"

module PostcodeHelper

  # Formats the incoming result into an array for display on the postcode
  # results selection form.
  # @param [Hash] result a hash of addresses from the postcode lookup
  # @return [Array] a nested array of addresses.  An address in the array has
  # comma separated address details and is associated with a UDPRN
  def result_formatter(result)
    [
        [
            [
                result[:line_1], result[:line_2], result[:line_3]
            ].reject(&:empty?)
        ].join(', '),
        result[:udprn]
    ]

  end

  # Uses the uk_postcode gem to check the validity of a postcode
  # @param [String] postcode the postcode
  # @return [boolean] whether or not the postcode was valid
  def validate_postcode_format(postcode)
    UKPostcode.parse(postcode).full_valid?
  end
end
