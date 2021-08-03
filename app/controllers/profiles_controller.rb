class ProfilesController < ApplicationController
   def index
    @user = User.find(1)
    raise Forbidden unless user_safe?

    @skill_categories = user_reccomend_skill_categories
    @articles = @user.articles.preload(:tags)
    #ループ内で関連テーブルの値を使用する場合 pre
    end

  private
#ユーザーに紐づく全てのユーザー凍結情報の終了時間と現在時間を比較し、現在凍結期間外である事の確認
  def user_safe?
    @user.user_cautions.joins(:caution_freeze).
    where("caution_freezes.end_time > ?", Time.zone.now).blank?
  end

  def user_reccomend_skill_categories
    SkillCategory.eager_load(:skills).
    where(reccomend: true).
    where(skills: { user_id: @user.id })
  end
end
