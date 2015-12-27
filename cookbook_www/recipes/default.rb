package 'epel-release'
package 'nginx'
package 'php-fpm'

template '/etc/php-fpm.d/www.conf' do
  source 'www.conf.erb'
end

service 'php-fpm' do
  action :restart
end
