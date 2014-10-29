class CreateMemberPasswordReset < Struct.new(:member)
  def self.call(member, *args)
    new(member).call(*args)
  end

  def call
    member.password_reset_token = SecureRandom.urlsafe_base64
    member.password_reset_sent_at = Time.zone.now
    member.save!
    MemberMailer.delay.password_reset_link(member)
  end
end
