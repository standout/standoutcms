class MemberMailer < BaseMailer
  def approved(member, password)
    @website = member.website
    mail to: member.email,
      subject: subject(:approved, title: @website.title),
      content_type: "text/html",
      body: liquid("member_approved_email",
                   "member" => MemberDrop.new(member, password),
                   "website" => WebsiteDrop.new(@website))
  end

  def password_reset_link(member)
    @website = member.website
    mail to: member.email,
      subject: subject(:password_reset_link, title: @website.title),
      content_type: "text/html",
      body: liquid("member_password_reset_email",
                   "member" => MemberDrop.new(member),
                   "website" => WebsiteDrop.new(@website))
  end
end
