class MemberMailer < BaseMailer
  def approved(member, password)
    @website = member.website
    mail to: member.email,
      subject: "Ditt konto på #{@website.title} är nu godkänt",
      content_type: "text/html",
      body: liquid("member_approved_email",
                   "member" => MemberDrop.new(member, password))
  end
end
