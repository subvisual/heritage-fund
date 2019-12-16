class NotifyMailer < Mail::Notify::Mailer

  include Devise::Controllers::UrlHelpers

  def confirmation_instructions(record, token, opts = {})
    template_mail('a44293b7-7263-42b4-8905-44bbedaf1dfa',
                  to: record.email,
                  personalisation: {
                      confirmation_url: confirmation_url(record, confirmation_token: token)
                  }
    )
  end

  # Use ERB template as Notify does not support required templating logic.
  def email_changed(record, token, opts = {})
    @resource = record
    view_mail('cd9fbf07-4960-4cb7-903c-068b76d2ca32',
              to: @resource.email,
              subject: 'Email changed'
    )
  end


  def password_change(record, token, opts = {})
    template_mail('32bc1da4-99aa-4fde-9124-6c423cfcab15',
                  to: record.email,
    )
  end


  def reset_password_instructions(record, token, opts = {})
    template_mail('343c89d0-0825-4363-a2eb-6a6bbc20a50f',
                  to: record.email,
                  personalisation: {
                      edit_password_url: edit_password_url(record, reset_password_token: token)
                  }
    )
  end

  def unlock_instructions(record, token, opts = {})
    template_mail('8c03a7c0-e23f-484e-9543-bbde9263bd47',
                  to: record.email,
                  personalisation: {
                      unlock_url: unlock_url(record, unlock_token: token)
                  }
    )
  end
end
