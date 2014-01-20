#encoding: utf-8
class Personne < ActiveRecord::Base

	#################################################
	# Les personnes physiques. Appartiennent à un user
	# Les champs précédés de "p" correspondent à la 
	# personne à contacter en cas de problème
	#################################################
	has_many :groupe
	has_many :activite
	belongs_to :genre
	has_one :usertype
	belongs_to :user
	belongs_to :taillevetement
	has_many :commandes

	#attr_accessible :nom, :prenom, :phone, :email, :assurance

#### VALIDATIONS ##############################################################

###### Attributs ##############################################################

	# validates :email, presence: true
	validates :email, :format => { :with => /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/}
	# validates :nom, presence: true
	validates :nom , :length => { :in => 2..30 }
	# validates :prenom, presence: true
	validates :prenom , :length => { :in => 2..30 }
	validates :phone, :format => { :with => /\A((0|\+[1-9]{2})[1-9][0-9]{8})?\Z/ }
	# validates :assurance ,:inclusion => {  :in => [true,false]}
	validates :adresse , :presence => true
	validates :ville , :presence => true
	validates :codepostal , :presence => true
	validates :taille , :presence => true
	validates :taille , :numericality => true
	validates :pointure , :presence => true
	validates :pointure , :numericality => true

	# validates :pnom, presence: true
	validates :pnom , :length => { :in => 2..30 }
	# validates :pprenom, presence: true
	validates :pprenom , :length => { :in => 2..30 }
	validates :plienparente, presence: true
	validates :pphone, :format => { :with => /\A((0|\+[1-9]{2})[1-9][0-9]{8})?\Z/ }
	validates :padresse , :presence => true
	validates :pville , :presence => true
	validates :pcodepostal , :presence => true

	# validates :documentassurance, :inclusion => {  :in => [true,false]}
	# validates :enregistrement_termine, :inclusion => {  :in => [true,false]}
	


###### Associations ###########################################################
	validates :user, presence: true
	validates :genre, presence: true
	validates :taillevetement, presence: true

###############################################################################
	  # EXTRACT FROM SCHEMA
	  # create_table "personnes", force: true do |t|
	  #   t.string   "email"
	  #   t.string   "nom"
	  #   t.string   "prenom"
	  #   t.string   "phone"
	  #   t.datetime "naissance"
	  #   t.integer  "genre_id"
	  
	  #   t.boolean  "assurance"
	  #   t.datetime "created_at"
	  #   t.datetime "updated_at"
	  #   t.integer  "user_id"
	  
	  #   t.string   "adresse"
	  #   t.string   "ville"
	  #   t.integer  "codepostal"
		  #   t.string   "bucque"
		  #   t.string   "fams"
		  #   t.string   "promo"
		  #   t.string   "idGadzOrg"
	  #   t.integer  "taille"
	  #   t.integer  "pointure"
	  #   t.integer  "taillevetement_id"
	  #   t.string   "complement"
	  
	  #   t.string   "pnom"
	  #   t.string   "pprenom"
	  #   t.string   "plienparente"
	  #   t.string   "padresse"
	  #   t.string   "pcomplement"
	  #   t.string   "pville"
	  #   t.string   "pcodepostal"
	  #   t.string   "pphone"
	  
	  
	  #   t.boolean  "documentassurance"
	  #   t.boolean  "enregistrement_termine"
	  # end

#=== Méthodes publiques ==============================================

def nom_complet
    return self.prenom.to_s+" "+self.nom.to_s
end

def taille_metre
	if self.taille
		return self.taille / 100.0
	end
end

def referant
	return self.user.referant 
end

def is_referant?
	self == self.user.referant 
end

def referant?
	if self == self.user.referant 
		return "Compte référent"
	else
		return "Lié au compte de :" + self.referant.nom_complet
	end
end

def is_gadz?
	#A IMPLEMENTER
	true
end


def assure?
	return self.assurance 
end

def document_assurance
	if assure?
		if self.documentassurance
			return "Document fourni"
		else
			return "Docuement à fournir ou en cours de traitement"
		end
	else
		return "Assurance à commander dans les produits"
	end 
end

def p_nom_complet
    return self.pprenom.to_s+" "+self.pnom.to_s
end

def sync_from_user(user)
  self.prenom = user.first_name
  self.nom=user.last_name
  self.genre=Genre.from_cas(user.gender)
  self.email=user.email
  self.idGadzOrg=user.uid

  self.save(:validate => false)
end


end
