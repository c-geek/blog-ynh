#/bin/bash

INSTALL_CBLOG_PACKAGE () {

  # Install python dependencies
  sudo apt-get install -y python-pip python-virtualenv python-dev libldap2-dev libsasl2-dev libssl-dev
  
  # Create the virtualenv
  virtualenv ~/virtualenvs/cblog
  cd ~/virtualenvs/cblog
  source bin/activate
  
  # Clone the cblog sources
  git clone https://github.com/c-geek/blog cblog && cd cblog
  SRC=`pwd`
  
  # Install pelican
  pip install pelican pelican-youtube
  
  # Add the `medius` them
  pelican-themes --install medius/
  
  # Generate the blog
  pelican
  
  # Create a link to www/ folder
  if [[ -L /var/www/cblog ]]; then
    sudo rm /var/www/cblog
  fi
  sudo ln -s $SRC/output /var/www/cblog

  # Change owner
  sudo chown www-data:www-data -R $SRC/output/.
}

INSTALL_NGINX_CONFIGURATION () {
  # Configure Nginx
  nginx_conf="../conf/nginx.conf"
  sudo cp $nginx_conf /etc/nginx/conf.d/$domain.d/$app.conf
  sudo nginx -t && sudo service nginx reload
}
