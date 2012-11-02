require 'data-anonymization'
require 'mysql'

module DataAnon
  module Strategy
    module Field
      class MD5FieldStrategy
        def anonymize field
          #Digest::MD5.hexdigest(DataAnon::Utils::RandomString.generate(5))
          Digest::MD5.hexdigest('password');
        end
      end
    end
  end
end

database 'Moodle' do
  strategy DataAnon::Strategy::Blacklist
  source_db :adapter => 'mysql', :database => 'moodle', :username => 'root', :password => 'password'
  table 'mdl_user' do
    primary_key 'id'
    anonymize('firstname').using FieldStrategy::RandomFirstName.new
	anonymize('lastname').using FieldStrategy::RandomLastName.new
	anonymize('username').using FieldStrategy::RandomUserName.new
	anonymize('email').using FieldStrategy::RandomEmail.new('example','com')
    anonymize('password') {|field| 'password' }
	anonymize('institution').using FieldStrategy::RandomProvince.region_US
    anonymize('password').using FieldStrategy::MD5FieldStrategy.new
    anonymize('icq').using FieldStrategy::RandomInteger.new(5000,10000)
	anonymize('skype').using FieldStrategy::RandomUserName.new
	anonymize('yahoo').using FieldStrategy::RandomUserName.new
	anonymize('aim').using FieldStrategy::RandomUserName.new
	anonymize('msn').using FieldStrategy::RandomUserName.new
	anonymize('phone1').using FieldStrategy::RandomPhoneNumber.new
	anonymize('phone2').using FieldStrategy::RandomPhoneNumber.new
	anonymize('address').using FieldStrategy::RandomAddress.region_UK
	anonymize('city').using FieldStrategy::RandomCity.region_UK
	anonymize('lastip').using FieldStrategy::RandomUrl.new
	anonymize('url').using FieldStrategy::RandomUrl.new
	anonymize 'description', 'imagealt'	
  end
end
