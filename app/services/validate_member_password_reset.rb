class ValidateMemberPasswordReset < Struct.new(:member)
  def self.call(member, token)
    new(member).call(token)
  end

  def call(token)
    return false unless member.password_reset_sent_at.present?
    return false unless member.password_reset_sent_at + 8.hours > Time.zone.now
    return false unless member.password_reset_token.present?
    return false unless member.password_reset_token == token
    true
  end
end
