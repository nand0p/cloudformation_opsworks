package 'epel-release'
package 'nginx'
package 'php-fpm'
package 'jwhois'

template '/etc/php-fpm.d/www.conf' do
  owner 'root'
  group 'root'
  mode '0644'
  source 'www.conf.erb'
end

directory '/var/www' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end
