module FundingApplication::HefLoan::FormHelper

  # Method to retrieve an array of GUIDs for each static OrgIncomeType
  def retrieve_static_org_income_type_ids

    static_rows = OrgIncomeType.where(
      name: [
        'Government contract',
        'Rental Income',
        'Membership fees',
        'Grants',
        'Donations',
        'Trading'
      ]
    )

    static_row_ids = static_rows.map{|static_row| static_row.id}

  end

  # Method to retrieve an array of GUIDs for each static OrgType
  def retrieve_static_org_type_ids

    static_rows = OrgType.where(
      name: [
        'Registered charity',
        'Registered company',
        'Community Interest company',
        'Faith-based organisation',
        'Church organisation',
        'Community group',
        'Voluntary group',
        'Individual private owner of heritage'
      ]
    )

    static_row_ids = static_rows.map{|static_row| static_row.id}

  end

end
