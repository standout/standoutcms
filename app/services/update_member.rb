class UpdateMember < Struct.new(:member, :permitted_params)
  def self.call(*args)
    new(*args).call
  end

  def call
    member.attributes = permitted_params

    is_approval = member.approved_changed? && member.approved
    password = is_approval ? member.send(:generate_password) : nil

    if saved = member.save
      MemberMailer.delay.approved(member, password) if is_approval
    end

    saved
  end
end
