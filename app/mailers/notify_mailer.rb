class NotifyMailer < Mail::Notify::Mailer

  include Devise::Controllers::UrlHelpers

  def reset_password_instructions(record, token, opts={})
    template_mail('343c89d0-0825-4363-a2eb-6a6bbc20a50f',
                  to: record.email,
                  personalisation: {
                      'edit_password_url' => edit_password_url(record, reset_password_token: token)
                  }
    )
  end

end