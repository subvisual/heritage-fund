class SupportMailer < ActionMailer::Base

  def report_a_problem_email(message, name, email)

    @problem = message
    @name = name
    @email = email

    # TODO: Replace email address and subject line
    mail(to: "stuart.mccoll@heritagefund.org.uk", subject: "Test")

  end

end