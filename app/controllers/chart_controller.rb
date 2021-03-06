class ChartController < ApplicationController
	# json pour le gros graph
  # caches_action :etatcommande,  :expires_in => 0.minutes

  before_action :admin_only
  before_action :check_register_workflow

  def etatcommande
    # expire_action :action => :etatcommande
  	render :json => Tbk.all.map{|t| [t.nom,  t.commandes.all.map{|c| c.complete? if !c.personne.nil?}.count(false)]}
  end

  def etapepaiement
    a = Commande.all.map{|c| c.paiement_etape}
    etapes = a.each_with_object(Hash.new(0)) { |word,counts| counts[word] += 1 }
    render :json => etapes
  end

  def paiement
  	@paiement=Paiement.all
  	@commandes=Commande.all
  	@paiement_tot_euro=@paiement.all.map{ |p| p.amount_cents  if p.verif?}.compact.sum / 100.0
  	total_euro=@commandes.all.map { |c| c.montant_total }.sum / 100.0
    @total_du_euro=total_euro-@paiement_tot_euro
  	a=[
  		["Total payé", @paiement_tot_euro],
  		["Total dû", @total_du_euro.floor]]
  	render :json => a
  end

  def tbkcommandes
  	@tbkcom=Array.new
  	Tbk.all.each_with_index do |t,i| 
  		@tbkcom<<[t.nom,t.commandes.count] 
  	end
  	render :json => @tbkcom
  end

  def statsbus
    #params categorie_id, event_id 
    b=Categorie.find(params[:categorie_id]).products.where(event_id: params[:event_id]).map{|p| [p.name, p.commande_products.map{|cp| cp.nombre}.sum]}
    render :json => b
  end

  def statsinsctiptions
    b=User.all.group_by(&:group_by_date_sqlite).map {|k,v| [k, v.length]}.sort
    render :json => b
  end

  def choix_resids
    b=Paiement.where(verif: true).map{|p| p.commande}.uniq.map{|c| c.personne}.map{|p| p.typeresid.name if p.typeresid}.inject(Hash.new(0)) { |h, e| h[e] += 1 ; h }
    render :json => b
  end

  private

end
