class CreatePeople < ActiveRecord::Migration
  
  #People is a shadow model that allows us to create User records without going through the password verification. Since they have andrew accounts, they don't need passwords
  
  def self.up
#    create_table :people do |t|
#      t.string :twiki_name
#      t.string :first_name
#      t.string :last_name
#      t.string :human_name #derived column, updated in before_save
#      t.boolean :is_staff,     :default => false
#      t.boolean :is_student,   :default => false
#      t.boolean :is_admin,     :default => false   
#      t.string :webiso_account
#      t.string :image_uri
#      t.string :graduation_year #student field
#      t.string :masters_program #student field
#      t.string :masters_track   #student field
#      t.boolean :is_part_time   #student field
#      t.column :remember_token,            :string, :limit => 40
#      t.column :remember_token_expires_at, :datetime
#      t.timestamps
#    end
#    add_index :people, :human_name
    
    
    Person.create :twiki_name => "ToddSedano",      :is_staff => true, :first_name => "Todd", :last_name => "Sedano", :webiso_account => "at33@andrew.cmu.edu"
    Person.create :twiki_name => "EdKatz",          :is_staff => true, :first_name => "Ed", :last_name => "Katz", :webiso_account => "edkatz@andrew.cmu.edu"
    Person.create :twiki_name => "ReedLetsinger",   :is_staff => true, :first_name => "Reed", :last_name => "Letsinger", :webiso_account => "reedl@andrew.cmu.edu"
    Person.create :twiki_name => "MartinRadley",    :is_staff => true, :first_name => "Martin", :last_name => "Radley", :webiso_account => "mradley@andrew.cmu.edu"
    Person.create :twiki_name => "GladysMercier",   :is_staff => true, :first_name => "Gladys", :last_name => "Mercier", :webiso_account => "gmercier@andrew.cmu.edu"
    Person.create :twiki_name => "TonyWasserman",   :is_staff => true, :first_name => "Tony", :last_name => "Wasserman", :webiso_account => "aiw@andrew.cmu.edu"
    Person.create :twiki_name => "PatriciaCollins", :is_staff => true, :first_name => "Patricia", :last_name => "Collins", :webiso_account => "pcollins@andrew.cmu.edu"
    Person.create :twiki_name => "RayBareiss",      :is_staff => true, :first_name => "Ray", :last_name => "Bareiss", :webiso_account => "bareiss@andrew.cmu.edu"
    Person.create :twiki_name => "RahulArora",      :is_staff => true, :first_name => "Rahul", :last_name => "Arora", :webiso_account => "rahul@andrew.cmu.edu"
    Person.create :twiki_name => "JazzAyvazyan",    :is_staff => true, :first_name => "Jazz", :last_name => "Ayvazyan", :webiso_account => "armena@andrew.cmu.edu", :is_admin => true
    Person.create :twiki_name => "DianeDimeff",     :is_staff => true, :first_name => "Diane", :last_name => "Dimeff", :webiso_account => "ddimeff@andrew.cmu.edu"
    Person.create :twiki_name => "JimMorris",       :is_staff => true, :first_name => "Jim", :last_name => "Morris", :webiso_account => "jhm@andrew.cmu.edu"
    Person.create :twiki_name => "MartinGriss",     :is_staff => true, :first_name => "Martin", :last_name => "Griss", :webiso_account => "griss@andrew.cmu.edu"
    
#    Person.create :twiki_name => "ToddSedano",      :is_staff => false, :first_name => "Todd", :last_name => "Admin Account", :login => "todd.sedano@sv.cmu.edu", :is_admin => true, :email=>"todd.sedano@sv.cmu.edu"
    
    
    # SE students, Class of 2009
    Person.create :is_student => true, :is_part_time => true, :graduation_year => "2009", :masters_program => "SE", :masters_track => "Tech", :twiki_name => "NicholasLynn", :first_name => "Nicholas", :last_name => "Lynn", :image_uri => "/images/students/2009/SE/NicholasLynn.jpg", :webiso_account => "ngl@andrew.cmu.edu"
    Person.create :is_student => true, :is_part_time => true, :graduation_year => "2009", :masters_program => "SE", :masters_track => "DM", :twiki_name => "KennethRalph", :first_name => "Kenneth", :last_name => "Ralph", :image_uri => "/images/students/2009/SE/KenRalph.jpg", :webiso_account => "kralph@andrew.cmu.edu"
    Person.create :is_student => true, :is_part_time => true, :graduation_year => "2009", :masters_program => "SE", :masters_track => "DM", :twiki_name => "NathanChan", :first_name => "Nathan", :last_name => "Chan", :image_uri => "/images/students/2009/SE/NathanChan.jpg", :webiso_account => "nathanc@andrew.cmu.edu"
    Person.create :is_student => true, :is_part_time => true, :graduation_year => "2009", :masters_program => "SE", :masters_track => "Tech", :twiki_name => "PoonamGupta", :first_name => "Poonam", :last_name => "Gupta", :image_uri => "/images/students/2009/SE/PoonamGupta.jpg", :webiso_account => "poonamg@andrew.cmu.edu"
    Person.create :is_student => true, :is_part_time => true, :graduation_year => "2009", :masters_program => "SE", :masters_track => "DM", :twiki_name => "JohnRusnak", :first_name => "John", :last_name => "Rusnak", :image_uri => "/images/students/2009/SE/JohnRusnak.jpg", :webiso_account => "jrusnak@andrew.cmu.edu"
    Person.create :is_student => true, :is_part_time => true, :graduation_year => "2009", :masters_program => "SE", :masters_track => "DM", :twiki_name => "GraysonDeitering", :first_name => "Grayson", :last_name => "Deitering", :image_uri => "/images/students/2009/SE/GraysonDeitering.jpg", :webiso_account => "ged@andrew.cmu.edu"
    Person.create :is_student => true, :is_part_time => true, :graduation_year => "2009", :masters_program => "SE", :masters_track => "DM", :twiki_name => "CheauLongNg", :first_name => "Cheau Long", :last_name => "Ng", :image_uri => "/images/students/2009/SE/CheauLongNg.jpg", :webiso_account => "ncheaulo@andrew.cmu.edu"
    Person.create :is_student => true, :is_part_time => true, :graduation_year => "2009", :masters_program => "SE", :masters_track => "DM", :twiki_name => "JoshuaCorrea", :first_name => "Joshua", :last_name => "Correa", :image_uri => "/images/students/2009/SE/JoshuaCorrea.jpg", :webiso_account => "joshuaco@andrew.cmu.edu"
    Person.create :is_student => true, :is_part_time => true, :graduation_year => "2009", :masters_program => "SE", :masters_track => "Tech", :twiki_name => "ShreerangSudame", :first_name => "Shreerang", :last_name => "Sudame", :image_uri => "/images/students/2009/SE/ShreerangSudame.jpg", :webiso_account => "sssudame@andrew.cmu.edu"
    Person.create :is_student => true, :is_part_time => true, :graduation_year => "2009", :masters_program => "SE", :masters_track => "Tech", :twiki_name => "MarioCampaz", :first_name => "Mario", :last_name => "Campaz", :image_uri => "/images/students/2009/SE/MarioCampaz.jpg", :webiso_account => "mcampaz@andrew.cmu.edu"
    Person.create :is_student => true, :is_part_time => true, :graduation_year => "2009", :masters_program => "SE", :masters_track => "DM", :twiki_name => "SirishaPillalamarri", :first_name => "Sirisha", :last_name => "Pillalamarri", :image_uri => "/images/students/2009/SE/SirishaPillalamarri.jpg", :webiso_account => "spillala@andrew.cmu.edu"
    Person.create :is_student => true, :is_part_time => true, :graduation_year => "2009", :masters_program => "SE", :masters_track => "Tech", :twiki_name => "AmandeepRiar", :first_name => "Amandeep", :last_name => "Riar", :image_uri => "/images/students/2009/SE/AmandeepRiar.jpg", :webiso_account => "ariar@andrew.cmu.edu"
    Person.create :is_student => true, :is_part_time => true, :graduation_year => "2009", :masters_program => "SE", :masters_track => "DM", :twiki_name => "ArupKanjilal", :first_name => "Arup", :last_name => "Kanjilal", :image_uri => "/images/students/2009/SE/ArupKanjilal.jpg", :webiso_account => "akanjila@andrew.cmu.edu"
    Person.create :is_student => true, :is_part_time => true, :graduation_year => "2009", :masters_program => "SE", :masters_track => "DM", :twiki_name => "MajidAlShehry", :first_name => "Majid", :last_name => "AlShehry", :image_uri => "/images/students/2009/SE/MajidAlShehry.jpg", :webiso_account => "malshehr@andrew.cmu.edu"
    Person.create :is_student => true, :is_part_time => true, :graduation_year => "2009", :masters_program => "SE", :masters_track => "Tech", :twiki_name => "KarthikSankar", :first_name => "Karthik", :last_name => "Sankar", :image_uri => "/images/students/2009/SE/KarthikSankar.jpg", :webiso_account => "ksankar@andrew.cmu.edu"
    Person.create :is_student => true, :is_part_time => true, :graduation_year => "2009", :masters_program => "SE", :masters_track => "Tech", :twiki_name => "DaveNugent", :first_name => "Dave", :last_name => "Nugent", :image_uri => "/images/students/2009/SE/DaveNugent.jpg", :webiso_account => "dnugent@andrew.cmu.edu"
    Person.create :is_student => true, :is_part_time => true, :graduation_year => "2009", :masters_program => "SE", :masters_track => "Tech", :twiki_name => "HarleyHolliday", :first_name => "Harley", :last_name => "Holliday", :image_uri => "/images/students/2009/SE/HarleyHolliday.jpg", :webiso_account => "hhlliday@andrew.cmu.edu"
    Person.create :is_student => true, :is_part_time => true, :graduation_year => "2009", :masters_program => "SE", :masters_track => "DM", :twiki_name => "AnilDave", :first_name => "Neil", :last_name => "Dave", :image_uri => "/images/students/2009/SE/AnilDave.jpg", :webiso_account => "anild@andrew.cmu.edu"
    Person.create :is_student => true, :is_part_time => true, :graduation_year => "2009", :masters_program => "SE", :masters_track => "DM", :twiki_name => "WeiminLiu", :first_name => "Weimin", :last_name => "Liu", :image_uri => "/images/students/2009/SE/WeiminLiu.jpg", :webiso_account => "weiminl@andrew.cmu.edu"
    Person.create :is_student => true, :is_part_time => true, :graduation_year => "2009", :masters_program => "SE", :masters_track => "DM", :twiki_name => "SamPan", :first_name => "Sam", :last_name => "Pan", :image_uri => "/images/students/2009/SE/SamPan.jpg", :webiso_account => "sampan@andrew.cmu.edu"

    # SM students, Class of 2009
    Person.create :is_student => true, :is_part_time => true, :graduation_year => "2009", :masters_program => "SM", :twiki_name => "AdellGraham", :first_name => "Adell", :last_name => "Graham", :image_uri => "/images/students/2009/SM/AdellGraham.jpg", :webiso_account => "agraham@andrew.cmu.edu"
    Person.create :is_student => true, :is_part_time => true, :graduation_year => "2009", :masters_program => "SM", :twiki_name => "AlokRishi", :first_name => "Alok", :last_name => "Rishi", :image_uri => "/images/students/2009/SM/AlokRishi.jpg", :webiso_account => "arishi@andrew.cmu.edu"
    Person.create :is_student => true, :is_part_time => true, :graduation_year => "2009", :masters_program => "SM", :twiki_name => "CarlHickman", :first_name => "Carl", :last_name => "Hickman", :image_uri => "/images/students/2009/SM/CarlHickman.jpg", :webiso_account => "cahickma@andrew.cmu.edu"
    Person.create :is_student => true, :is_part_time => true, :graduation_year => "2009", :masters_program => "SM", :twiki_name => "DanielMaycock", :first_name => "Daniel", :last_name => "Maycock", :image_uri => "/images/students/2009/SM/DanielMaycock.jpg", :webiso_account => "dmaycock@andrew.cmu.edu"
    Person.create :is_student => true, :is_part_time => true, :graduation_year => "2009", :masters_program => "SM", :twiki_name => "DungNguyen", :first_name => "Dung", :last_name => "Nguyen", :image_uri => "/images/students/2009/SM/DungNguyen.jpg", :webiso_account => "dhnguyen@andrew.cmu.edu"
    Person.create :is_student => true, :is_part_time => true, :graduation_year => "2009", :masters_program => "SM", :twiki_name => "GitaKrishnamurthy", :first_name => "Gita", :last_name => "Krishnamurthy", :image_uri => "/images/students/2009/SM/GitaKrishnamurthy.jpg", :webiso_account => "gkrishna@andrew.cmu.edu"
    Person.create :is_student => true, :is_part_time => true, :graduation_year => "2009", :masters_program => "SM", :twiki_name => "HomajeetCheema", :first_name => "Homajeet", :last_name => "Cheema", :image_uri => "/images/students/2009/SM/HomajeetCheema.jpg", :webiso_account => "hcheema@andrew.cmu.edu"
    Person.create :is_student => true, :is_part_time => true, :graduation_year => "2009", :masters_program => "SM", :twiki_name => "IvettaStarikova", :first_name => "Ivetta", :last_name => "Starikova", :image_uri => "/images/students/2009/SM/IvettaStarikova.jpg", :webiso_account => "istariko@andrew.cmu.edu"
    Person.create :is_student => true, :is_part_time => true, :graduation_year => "2009", :masters_program => "SM", :twiki_name => "JarekWilkiewicz", :first_name => "Jarek", :last_name => "Wilkiewicz", :image_uri => "/images/students/2009/SM/JarekWilkiewicz.jpg", :webiso_account => "wilkiew@andrew.cmu.edu"
    Person.create :is_student => true, :is_part_time => true, :graduation_year => "2009", :masters_program => "SM", :twiki_name => "JohnGibson", :first_name => "John", :last_name => "Gibson", :image_uri => "/images/students/2009/SM/JohnGibson.jpg", :webiso_account => "johngibs@andrew.cmu.edu"
    Person.create :is_student => true, :is_part_time => true, :graduation_year => "2009", :masters_program => "SM", :twiki_name => "JohnHenry", :first_name => "John Henry", :last_name => "Mathias", :image_uri => "/images/students/2009/SM/JohnHenryMathias.jpg", :webiso_account => "jmithias@andrew.cmu.edu"
    Person.create :is_student => true, :is_part_time => true, :graduation_year => "2009", :masters_program => "SM", :twiki_name => "KashifMehmood", :first_name => "Kashif", :last_name => "Mehmood", :image_uri => "/images/students/2009/SM/KashifMehmood.jpg", :webiso_account => "kmehmood@andrew.cmu.edu"
    Person.create :is_student => true, :is_part_time => true, :graduation_year => "2009", :masters_program => "SM", :twiki_name => "TeraReddy", :first_name => "Tera", :last_name => "Reddy", :image_uri => "/images/students/2009/SM/TeraReddy.jpg", :webiso_account => "tkr@andrew.cmu.edu"
    Person.create :is_student => true, :is_part_time => true, :graduation_year => "2009", :masters_program => "SM", :twiki_name => "LeonardLau", :first_name => "Leonard", :last_name => "Lau", :image_uri => "/images/students/2009/SM/LeonardLau.jpg", :webiso_account => "llau1@andrew.cmu.edu"
    Person.create :is_student => true, :is_part_time => true, :graduation_year => "2009", :masters_program => "SM", :twiki_name => "LingWang", :first_name => "Ling", :last_name => "Wang", :image_uri => "/images/students/2009/SM/LingWang.jpg", :webiso_account => "lingw@andrew.cmu.edu"
    Person.create :is_student => true, :is_part_time => true, :graduation_year => "2009", :masters_program => "SM", :twiki_name => "MuhammadSiddiqui", :first_name => "Muhammad", :last_name => "Siddiqui", :image_uri => "/images/students/2009/SM/MuhammadAliSiddiqui.jpg", :webiso_account => "msiddiqu@andrew.cmu.edu"
    Person.create :is_student => true, :is_part_time => true, :graduation_year => "2009", :masters_program => "SM", :twiki_name => "NancyKuettel", :first_name => "Nancy", :last_name => "Kuettel", :image_uri => "/images/students/2009/SM/NancyKuettel.jpg", :webiso_account => "ntk@andrew.cmu.edu"
    Person.create :is_student => true, :is_part_time => true, :graduation_year => "2009", :masters_program => "SM", :twiki_name => "NileshJain", :first_name => "Nilesh", :last_name => "Jain", :image_uri => "/images/students/2009/SM/NileshJain.jpg", :webiso_account => "jnilesh@andrew.cmu.edu"
    
    Person.create :is_student => true, :is_part_time => true, :graduation_year => "2009", :masters_program => "SM", :twiki_name => "NiranjanVanungare", :first_name => "Niranjan", :last_name => "Vanungare", :image_uri => "/images/students/2009/SM/NiranjanVanungare.jpg", :webiso_account => "nvanunga@andrew.cmu.edu"
    Person.create :is_student => true, :is_part_time => true, :graduation_year => "2009", :masters_program => "SM", :twiki_name => "PhillipMatuzic", :first_name => "Phillip", :last_name => "Matuzic", :image_uri => "/images/students/2009/SM/PhillipMatuzic.jpg", :webiso_account => "pmatuzic@andrew.cmu.edu"
    Person.create :is_student => true, :is_part_time => true, :graduation_year => "2009", :masters_program => "SM", :twiki_name => "PratyushDave", :first_name => "Pratyush", :last_name => "Dave", :image_uri => "/images/students/2009/SM/PratyushDave.jpg", :webiso_account => "pdave@andrew.cmu.edu"
    Person.create :is_student => true, :is_part_time => true, :graduation_year => "2009", :masters_program => "SM", :twiki_name => "SalimLakhani", :first_name => "Salim", :last_name => "Lakhani", :image_uri => "/images/students/2009/SM/SalimLakhani.jpg", :webiso_account => "sklakhan@andrew.cmu.edu"
    Person.create :is_student => true, :is_part_time => true, :graduation_year => "2009", :masters_program => "SM", :twiki_name => "LeeHenry", :first_name => "Sean", :last_name => "Henry", :image_uri => "/images/students/2009/SM/SeanHenry.jpg", :webiso_account => "lhenry@andrew.cmu.edu"
    Person.create :is_student => true, :is_part_time => true, :graduation_year => "2009", :masters_program => "SM", :twiki_name => "SushmithaBhaskaran", :first_name => "Sushmitha", :last_name => "Bhaskaran", :image_uri => "/images/students/2009/SM/SushmithaBhaskaran.jpg", :webiso_account => "sbhaskar@andrew.cmu.edu"
    Person.create :is_student => true, :is_part_time => true, :graduation_year => "2009", :masters_program => "SM", :twiki_name => "ThomasBoyd", :first_name => "Thomas", :last_name => "Boyd", :image_uri => "/images/students/2009/SM/ThomasBoyd.jpg", :webiso_account => "tcboyd@andrew.cmu.edu@andrew.cmu.edu"
    Person.create :is_student => true, :is_part_time => true, :graduation_year => "2009", :masters_program => "SM", :twiki_name => "VivekSinha", :first_name => "Vivek", :last_name => "Sinha", :image_uri => "/images/students/2009/SM/VivekSinha.jpg", :webiso_account => "vsinha@andrew.cmu.edu"
    

#    Person.create :is_student => true, :is_part_time => true, :graduation_year => "2009", :masters_program => "SM", :twiki_name => "", :first_name => "", :last_name => "", :image_uri => "/images/students/2009/SM/.jpg"
    
  end

  def self.down
#    drop_table :people    
  end
end
