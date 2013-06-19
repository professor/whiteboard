require "spec_helper"

describe "ActiveDirectory" do

  before do
    @ldap_server = Ladle::Server.new(:quiet => true, :port=>3897).start
    @faculty_frank = FactoryGirl.create(:faculty_frank, email: "faculty.frank@sandbox.sv.cmu.edu")
    @active_directory_services = ActiveDirectory.new
  end

  after do
    @ldap_server.stop if @ldap_server
  end

  it 'ldap_distinguished_name method returns valid distinguished name for staff' do
    @active_directory_services.ldap_distinguished_name(@faculty_frank).should eq("cn=Faculty Frank,ou=Staff,ou=Sync,dc=cmusv,dc=sv,dc=cmu,dc=local")
  end

  it 'ldap_distinguished_name method returns valid distinguished name for student' do
    @student_sam = FactoryGirl.create(:student_sam, masters_program: 'SE')
    @active_directory_services.ldap_distinguished_name(@student_sam).should eq("cn=Student Sam,ou=SE,ou=Students,ou=Sync,dc=cmusv,dc=sv,dc=cmu,dc=local")
  end

  it 'ldap_attributes method returns necessary ldap attributes' do
    @active_directory_services.ldap_attributes(@faculty_frank).should include( :cn=>"Faculty Frank",
                                                                              :mail=>"faculty.frank@sandbox.sv.cmu.edu",
                                                                              :objectclass=>["top", "person", "organizationalPerson", "user"],
                                                                              :userPrincipalName=>"faculty.frank@sandbox.sv.cmu.edu")
  end

  it 'password_encode method encodes password to hexadecimal base 64' do
    @active_directory_services.password_encode("pass").should == "\"\x00p\x00a\x00s\x00s\x00\"\x00"
  end

end
