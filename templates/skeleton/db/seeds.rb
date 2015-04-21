# -*- coding: utf-8 -*-
User.delete_all

User.create! email: 'admin@sinfin.cz', password: 'password'
puts "Created #{User.count} user(s)."
