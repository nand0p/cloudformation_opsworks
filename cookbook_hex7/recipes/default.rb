template '/etc/nginx/conf.d/hex7.conf' do
  source 'nginx.conf.erb'
end

git '/var/www/www.hex7.com' do
  repository 'https://github.com/nand0p/hex7.git'
  action :sync
end

service 'nginx' do
  action :restart
end

service 'php-fpm' do
  action :restart
end
