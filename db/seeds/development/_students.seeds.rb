require 'factory_girl'

FactoryGirl.define do

  factory :student_se_full_time, :parent => :person do
    is_student 1
    is_part_time 0
    graduation_year "2012"
    masters_program "SE"
    masters_track "Tech"
    sequence(:email) {|n| "sestudent#{n}@sv.cmu.edu"}
    sequence(:webiso_account) {|n| "sestudent#{n}@andrew.cmu.edu"}
  end

  factory :student_sm_full_time, :parent => :person do
    is_student 1
    is_part_time 0
    graduation_year "2012"
    masters_program "SM"
    masters_track "Tech"
    sequence(:email) {|n| "smstudent#{n}@sv.cmu.edu"}
    sequence(:webiso_account) {|n| "smstudent#{n}@andrew.cmu.edu"}
  end

  factory :student_magic_full_time, :parent => :person do
    is_student 1
    is_part_time 0
    graduation_year "2012"
    masters_program "MG"
    masters_track "Magic"
    sequence(:email) {|n| "mgstudent#{n}@sv.cmu.edu"}
    sequence(:webiso_account) {|n| "mgstudent#{n}@andrew.cmu.edu"}
  end

  factory :aristide, :parent => :student_se_full_time do
    twiki_name "AristideNiyungeko"
    first_name "Aristide"
    last_name "Niyungeko"
    human_name "Aristide Niyungeko"
  end

  factory :clyde, :parent => :student_se_full_time do
    twiki_name "ClydeLi"
    first_name "Clyde"
    last_name "Li"
    human_name "Clyde Li"
  end

  factory :david, :parent => :student_se_full_time do
    twiki_name "DavidLiu"
    first_name "David"
    last_name "Liu"
    human_name "David Liu"
  end

  factory :david_p, :parent => :student_se_full_time do
    twiki_name "DavidPfeffer"
    first_name "David"
    last_name "Pfeffer"
    human_name "David Pfeffer"
    image_uri "http://s3.amazonaws.com/cmusv-rails-production/people/photo/803/profile/030_DavidPfeffer.jpg"
  end

  factory :edward, :parent => :student_se_full_time do
    twiki_name "EdwardAkoto"
    first_name "Edward"
    last_name "Akoto"
    human_name "Edward Akoto"
  end

  factory :kate, :parent => :student_se_full_time do
    twiki_name "KateLiu"
    first_name "Kate"
    last_name "Liu"
    human_name "Kate Liu"
  end

  factory :kaushik, :parent => :student_se_full_time do
    twiki_name "KaushikGopal"
    first_name "Kaushik"
    last_name "Gopal"
    human_name "Kaushik Gopal"
  end

  factory :lydian, :parent => :student_se_full_time do
    twiki_name "LydianLee"
    first_name "Lydian"
    last_name "Lee"
    human_name "Lydian Lee"
  end

  factory :madhok, :parent => :student_se_full_time do
    twiki_name "MadhokShivaratre"
    first_name "Madhok"
    last_name "Shivaratre"
    human_name "Madhok Shivaratre"
  end

  factory :mark, :parent => :student_se_full_time do
    twiki_name "MarkHennessy"
    first_name "Mark"
    last_name "Hennessy"
    human_name "Mark Hennessy"
  end

  factory :norman, :parent => :student_se_full_time do
    twiki_name "NormanXin"
    first_name "Norman"
    last_name "Xin"
    human_name "Norman Xin"
  end

  factory :oscar, :parent => :student_se_full_time do
    twiki_name "OscarSandoval"
    first_name "Oscar"
    last_name "Sandoval"
    human_name "Oscar Sandoval"
  end

  factory :owen, :parent => :student_se_full_time do
    twiki_name "OwenChu"
    first_name "Owen"
    last_name "Chu"
    human_name "Owen Chu"
    image_uri "http://s3.amazonaws.com/cmusv-rails-production/people/photo/791/profile/057_OwenChu.jpg"
  end

  factory :prabhjot, :parent => :student_se_full_time do
    twiki_name "PrabhjotSingh"
    first_name "Prabhjot"
    last_name "Singh"
    human_name "Prabhjot Singh"
  end

  factory :rashmi, :parent => :student_se_full_time do
    twiki_name "RashmiDevarahalli"
    first_name "Rashmi"
    last_name "Devarahalli"
    human_name "Rashmi Devarahalli"
  end

  factory :sean, :parent => :student_se_full_time do
    twiki_name "SeanXiao"
    first_name "Sean"
    last_name "Xiao"
    human_name "Sean Xiao"
  end

  factory :shama, :parent => :student_se_full_time do
    twiki_name "ShamaRajeev"
    first_name "Shama"
    last_name "Rajeev"
    human_name "Shama Rajeev"
  end

  factory :sky, :parent => :student_se_full_time do
    twiki_name "SkyHu"
    first_name "Sky"
    last_name "Hu"
    human_name "Sky Hu"
    image_uri "http://s3.amazonaws.com/cmusv-rails-production/people/photo/795/profile/058_SkyHu.jpg"
  end

  factory :sumeet, :parent => :student_se_full_time do
    twiki_name "SumeetKumar"
    first_name "Sumeet"
    last_name "Kumar"
    human_name "Sumeet Kumar"
    image_uri "http://s3.amazonaws.com/cmusv-rails-production/people/photo/796/profile/044_SumeetKumar.jpg"
  end

  factory :vidya, :parent => :student_se_full_time do
    twiki_name "VidyaPissaye"
    first_name "Vidya"
    last_name "Pissaye"
    human_name "Vidya Pissaye"
  end

  factory :zhipeng, :parent => :student_se_full_time do
    twiki_name "ZhipengLi"
    first_name "Zhipeng"
    last_name "Li"
    human_name "Zhipeng Li"
  end

  factory :michael, :parent => :student_sm_full_time do
    twiki_name "MichaelJordan"
    first_name "Michael"
    last_name "Jordan"
    human_name "Michael Jordan"
  end

  factory :scottie, :parent => :student_sm_full_time do
    twiki_name "ScottiePippen"
    first_name "Scottie"
    last_name "Pippen"
    human_name "Scottie Pippen"
  end

  factory :dennis, :parent => :student_sm_full_time do
    twiki_name "DennisRodman"
    first_name "Dennis"
    last_name "Rodman"
    human_name "Dennis Rodman"
  end

  factory :harry, :parent => :student_magic_full_time do
    twiki_name "HarryPotter"
    first_name "Harry"
    last_name "Potter"
    human_name "Harry Potter"
    image_uri "http://upload.wikimedia.org/wikipedia/en/4/44/HarryPotter5poster.jpg"
  end

  factory :ron, :parent => :student_magic_full_time do
    twiki_name "RonWeasley"
    first_name "Ron"
    last_name "Weasley"
    human_name "Ron Weasley"
    image_uri "http://upload.wikimedia.org/wikipedia/en/thumb/5/5e/Ron_Weasley_poster.jpg/200px-Ron_Weasley_poster.jpg"
  end

  factory :hermione, :parent => :student_magic_full_time do
    twiki_name "HermioneGranger"
    first_name "Hermione"
    last_name "Granger"
    human_name "Hermione Granger"
    image_uri "http://www.hermionegrangerswand.com/images/hermione.jpg"
  end

  factory :neville, :parent => :student_magic_full_time do
    twiki_name "NevilleLongbottom"
    first_name "Neville"
    last_name "Longbottom"
    human_name "Neville Longbottom"
    image_uri "http://thesexylittlenerd.files.wordpress.com/2011/12/neville.jpg"
  end

  factory :draco, :parent => :student_magic_full_time do
    twiki_name "DracoMalfoy"
    first_name "Draco"
    last_name "Malfoy"
    human_name "Draco Malfoy"
    image_uri "http://2ch-tachiyomi.com/image/2012-11/30/20352-0.jpg"
  end

  factory :adam_blazczak, :parent => :person do
    is_student 1
    is_part_time 1
    graduation_year "2015"
    masters_program "SE"
    masters_track "Tech"
    twiki_name "AdamBlazczak"
    first_name "Adam"
    last_name "Blazczak"
    human_name "Adam Blazczak"
    email "adam.blazczak@sv.cmu.edu"
    webiso_account "ablazcza@andrew.cmu.edu"
  end

  factory :rohit_kabadi, :parent => :person do
    is_student 1
    is_part_time 1
    graduation_year "2015"
    masters_program "SE"
    masters_track "Tech"
    twiki_name "RohitKabadi"
    first_name "Rohit"
    last_name "Kabadi"
    human_name "Rohit Kabadi"
    email "rohit.kabadi@sv.cmu.edu"
    webiso_account "rkabadi@andrew.cmu.edu"
  end

  factory :joe_mirizio, :parent => :person do
    is_student 1
    is_part_time 1
    graduation_year "2015"
    masters_program "SE"
    masters_track "Tech"
    twiki_name "JoeMirizio"
    first_name "Joe"
    last_name "Mirizio"
    human_name "Joe Mirizio"
    email "joe.mirizio@sv.cmu.edu"
    webiso_account "jmirizio@andrew.cmu.edu"
  end

  factory :jason_duran, :parent => :person do
    is_student 1
    is_part_time 1
    graduation_year "2015"
    masters_program "SE"
    masters_track "Tech"
    twiki_name "JasonDuran"
    first_name "Jason"
    last_name "Duran"
    human_name "Jason Duran"
    email "jason.duran@sv.cmu.edu"
    webiso_account "jduran@andrew.cmu.edu"
  end

  factory :khoa_doba, :parent => :person do
    is_student 1
    is_part_time 1
    graduation_year "2015"
    masters_program "SE"
    masters_track "Tech"
    twiki_name "KhoaDoba"
    first_name "Khoa"
    last_name "Doba"
    human_name "Khoa Doba"
    email "khoa.doba@sv.cmu.edu"
    webiso_account "kdoba@andrew.cmu.edu"
  end

  factory :jacob_wu, :parent => :person do
    is_student 1
    is_part_time 1
    graduation_year "2015"
    masters_program "SE"
    masters_track "Tech"
    twiki_name "JacobWu"
    first_name "Jacob"
    last_name "Wu"
    human_name "Jacob Wu"
    email "jacob.wu@sv.cmu.edu"
    webiso_account "yuanjiaw@andrew.cmu.edu"
  end

  factory :hyo_jeong, :parent => :person do
    is_student 1
    is_part_time 1
    graduation_year "2015"
    masters_program "SE"
    masters_track "Tech"
    twiki_name "HyoJeong"
    first_name "Hyo"
    last_name "Jeong"
    human_name "Hyo Jeong"
    email "hyo.jeong@sv.cmu.edu"
    webiso_account "hyohyeoj@andrew.cmu.edu"
  end

  factory :harikumar_kumar_sulochana, :parent => :person do
    is_student 1
    is_part_time 1
    graduation_year "2015"
    masters_program "SE"
    masters_track "Tech"
    twiki_name "HarikumarKumarSulochana"
    first_name "Harikumar"
    last_name "Kumar Sulochana"
    human_name "Harikumar Kumar Sulochana"
    email "harikumar.kumar.sulochana@sv.cmu.edu"
    webiso_account "hkumarsu@andrew.cmu.edu"
  end

  factory :grace_lee, :parent => :person do
    is_student 1
    is_part_time 1
    graduation_year "2015"
    masters_program "SE"
    masters_track "Tech"
    twiki_name "GraceLee"
    first_name "Grace"
    last_name "Lee"
    human_name "Grace Lee"
    email "grace.lee@sv.cmu.edu"
    webiso_account "yeonjinl@andrew.cmu.edu"
  end

  factory :mariam_rajabi, :parent => :person do
    is_student 1
    is_part_time 0
    graduation_year "2014"
    masters_program "SE"
    masters_track "Tech"
    twiki_name "MariamRajabi"
    first_name "Mariam"
    last_name "Rajabi"
    human_name "Mariam Rajabi"
    email "mariam.rajabi@sv.cmu.edu"
    webiso_account "mrajabi@andrew.cmu.edu"
  end

  factory :anubhav_aeron, :parent => :person do
    is_student 1
    is_part_time 0
    graduation_year "2014"
    masters_program "SE"
    masters_track "Tech"
    twiki_name "AnubhavAeron"
    first_name "Anubhav"
    last_name "Aeron"
    human_name "Anubhav Aeron"
    email "anubhav.aeron@sv.cmu.edu"
    webiso_account "aaeron@andrew.cmu.edu"
  end

  factory :shishir_kinkar, :parent => :person do
    is_student 1
    is_part_time 0
    graduation_year "2014"
    masters_program "SE"
    masters_track "Tech"
    twiki_name "ShishirKinkar"
    first_name "Shishir"
    last_name "Kinkar"
    human_name "Shishir Kinkar"
    email "shishir.kinkar@sv.cmu.edu"
    webiso_account "ssk@andrew.cmu.edu"
  end

  factory :lyman_cao, :parent => :person do
    is_student 1
    is_part_time 0
    graduation_year "2014"
    masters_program "SE"
    masters_track "Tech"
    twiki_name "LymanCao"
    first_name "Lyman"
    last_name "Cao"
    human_name "Lyman Cao"
    email "lyman.cao@sv.cmu.edu"
    webiso_account "yifanc@andrew.cmu.edu"
  end

  factory :david_lee, :parent => :person do
    is_student 1
    is_part_time 0
    graduation_year "2014"
    masters_program "SE"
    masters_track "Tech"
    twiki_name "DavidLee"
    first_name "David"
    last_name "Lee"
    human_name "David Lee"
    email "david.lee@sv.cmu.edu"
    webiso_account "chihshal@andrew.cmu.edu"
  end

  factory :nelson_pollard, :parent => :person do
    is_student 1
    is_part_time 0
    graduation_year "2014"
    masters_program "SE"
    masters_track "Tech"
    twiki_name "NelsonPollard"
    first_name "Nelson"
    last_name "Pollard"
    human_name "Nelson Pollard"
    email "nelson.pollard@sv.cmu.edu"
    webiso_account "napollar@andrew.cmu.edu"
  end

  factory :surya_kiran, :parent => :person do
    is_student 1
    is_part_time 0
    graduation_year "2014"
    masters_program "SE"
    masters_track "Tech"
    twiki_name "SuryaKiran"
    first_name "Surya"
    last_name "Kiran"
    human_name "Surya Kiran"
    email "surya.kiran@sv.cmu.edu"
    webiso_account "slaskar@andrew.cmu.edu"
  end


  factory :isil_demir, :parent => :person do
    is_student 1
    is_part_time 0
    graduation_year "2014"
    masters_program "SE"
    masters_track "Tech"
    twiki_name "IsilDemir"
    first_name "Isil"
    last_name "Demir"
    human_name "Isil Demir"
    email "isil.demir@sv.cmu.edu"
    webiso_account "idemir@andrew.cmu.edu"
  end


  factory :anirudh_bhargava, :parent => :person do
    is_student 1
    is_part_time 0
    graduation_year "2014"
    masters_program "SE"
    masters_track "Tech"
    twiki_name "AnirudhBhargava"
    first_name "Anirudh"
    last_name "Bhargava"
    human_name "Anirudh Bhargava"
    email "anirudh.bhargava@sv.cmu.edu"
    webiso_account "abharga1@andrew.cmu.edu"
  end

  factory :gonghan_wang, :parent => :person do
    is_student 1
    is_part_time 0
    graduation_year "2014"
    masters_program "SE"
    masters_track "Tech"
    twiki_name "GonghanWang"
    first_name "Gonghan"
    last_name "Wang"
    human_name "Gonghan Wang"
    email "gonghan.wang@sv.cmu.edu"
    webiso_account "gonghanw@andrew.cmu.edu"
  end

  factory :ira_jain, :parent => :person do
    is_student 1
    is_part_time 0
    graduation_year "2014"
    masters_program "SE"
    masters_track "Tech"
    twiki_name "IraJain"
    first_name "Ira"
    last_name "Jain"
    human_name "Ira Jain"
    email "ira.jain@sv.cmu.edu"
    webiso_account "ij@andrew.cmu.edu"
  end

  factory :arie_radilla_laureano, :parent => :person do
    is_student 1
    is_part_time 0
    graduation_year "2014"
    masters_program "SE"
    masters_track "Tech"
    twiki_name "ArieRadillaLaureano"
    first_name "Arie"
    last_name "Radilla Laureano"
    human_name "Arie Radilla Laureano"
    email "arie.radilla.laureano@sv.cmu.edu"
    webiso_account "aradilla@andrew.cmu.edu"
  end

  factory :xueqiao_xu  , :parent => :person do
    is_student 1
    is_part_time 0
    graduation_year "2014"
    masters_program "SE"
    masters_track "Tech"
    twiki_name "XueqiaoXu"
    first_name "Xueqiao"
    last_name "Xu"
    human_name "Xueqiao Xu"
    email "xueqiao.xu@sv.cmu.edu"
    webiso_account "xueqiaox@andrew.cmu.edu"
  end


  factory :mridula_chappalli_srinivasa, :parent => :person do
    is_student 1
    is_part_time 0
    graduation_year "2014"
    masters_program "SE"
    masters_track "Tech"
    twiki_name "MridulaChappalliSrinivasa"
    first_name "Mridula"
    last_name "Chappalli Srinivasa"
    human_name "Mridula Chappalli Srinivasa"
    email "mridula.chappalli.srinivasa@sv.cmu.edu"
    webiso_account "mchappal@andrew.cmu.edu"
  end




end

Factory.create(:adam_blazczak)
Factory.create(:rohit_kabadi)
Factory.create(:joe_mirizio)
Factory.create(:jason_duran)
Factory.create(:khoa_doba)
Factory.create(:jacob_wu)
Factory.create(:hyo_jeong)
Factory.create(:harikumar_kumar_sulochana)
Factory.create(:grace_lee)
Factory.create(:mariam_rajabi)
Factory.create(:anubhav_aeron)
Factory.create(:shishir_kinkar)
Factory.create(:lyman_cao)
Factory.create(:david_lee)
Factory.create(:nelson_pollard)
Factory.create(:surya_kiran)
Factory.create(:isil_demir)
Factory.create(:anirudh_bhargava)
Factory.create(:gonghan_wang)
Factory.create(:ira_jain)
Factory.create(:arie_radilla_laureano)
Factory.create(:xueqiao_xu)
Factory.create(:mridula_chappalli_srinivasa)




