class UserDomain

  # standoutcms.* should lead to login page
  # *.standoutcms.* should lead to website index
  # mydomain.com should lead to website index
  # *.standoutcms.se/admin is all the admin stuff.

  def self.matches?(request)
    (
      (request.subdomain.present? && request.subdomain != 'www') ||
      (Website.find_by_domain(request.host.to_s) || Website.find_by_domainaliases(request.host.to_s))
    )
  end
end

class MainDomain
  def self.matches?(request)
    !request.subdomain.present? || ["www", "app"].include?(request.subdomain)
  end
end
