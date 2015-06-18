# -*- coding: utf-8 -*-
User.find_or_create_by(email: 'admin@sinfin.cz') { |u| u.password = 'password' }
