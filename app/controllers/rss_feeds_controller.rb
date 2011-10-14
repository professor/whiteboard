class RssFeedsController < ApplicationController
  before_filter :authenticate_user!, :except => :index

  # GET /rss_feeds
  # GET /rss_feeds.xml
  def index
    @rss_feeds = RssFeed.all
    puts "hello world"
    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @rss_feeds }
    end
  end

  # GET /rss_feeds/1
  # GET /rss_feeds/1.xml
  def show
    @rss_feed = RssFeed.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @rss_feed }
    end
  end

  # GET /rss_feeds/new
  # GET /rss_feeds/new.xml
  def new
    @rss_feed = RssFeed.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @rss_feed }
    end
  end

  # GET /rss_feeds/1/edit
  def edit
    @rss_feed = RssFeed.find(params[:id])
  end

  # POST /rss_feeds
  # POST /rss_feeds.xml
  def create
    @rss_feed = RssFeed.new(params[:rss_feed])

    respond_to do |format|
      if @rss_feed.save
        flash[:notice] = 'RssFeed was successfully created.'
        format.html { redirect_to(@rss_feed) }
        format.xml { render :xml => @rss_feed, :status => :created, :location => @rss_feed }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @rss_feed.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /rss_feeds/1
  # PUT /rss_feeds/1.xml
  def update
    @rss_feed = RssFeed.find(params[:id])

    respond_to do |format|
      if @rss_feed.update_attributes(params[:rss_feed])
        flash[:notice] = 'RssFeed was successfully updated.'
        format.html { redirect_to(@rss_feed) }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @rss_feed.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /rss_feeds/1
  # DELETE /rss_feeds/1.xml
  def destroy
    @rss_feed = RssFeed.find(params[:id])
    @rss_feed.destroy

    respond_to do |format|
      format.html { redirect_to(rss_feeds_url) }
      format.xml { head :ok }
    end
  end
end
