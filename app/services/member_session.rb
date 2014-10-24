class MemberSession < Struct.new(:session)
  private_class_method :new

  def self.update(session, member)
    new(session).update(member)
  end

  def self.destroy(session)
    new(session).destroy
  end

  def self.get(session, website)
    new(session).get(website)
  end

  def get(website)
    @website = website
    if website_same? && not_expired? && find_by_id
      prolong
    else
      destroy
    end
    @member
  end

  def update(member)
    session[:member_id] = member.id
    session[:member_website_id] = member.website_id
    prolong
    @member = member
  end

  def destroy
    session[:member_id] = nil
    session[:member_website_id] = nil
    @member = nil
  end

  private

  def prolong
    session[:member_expire_at] = 24.hours.from_now
  end

  def website_same?
    session[:member_website_id] == @website.id
  end

  def not_expired?
    session[:member_expire_at].present? &&
    session[:member_expire_at] > Time.zone.now
  end

  def find_by_id
    @member ||= @website.members.find(session[:member_id])
  end
end
