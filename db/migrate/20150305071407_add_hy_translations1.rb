# encoding: UTF-8

class AddHyTranslations1 < ActiveRecord::Migration
  def up
    locale = 'hy'

    CategoryTranslation.transaction do
      # categories
      puts "CATEGORIES"
      cat_en = ['All', 'Defence', 'Economy / Business', 'Education', 'Environment', 'Health / Public Safety', 'Justice', 'Lifestyle / Culture', 'Politics', 'Society', 'Sports', 'Technology / Science', 'World']
      cat_hy = ['Բոլորը', 'Պաշտպանություն', 'Տնտեսություն / բիզնես', 'Կրթություն', 'Շրջակա միջավայր', 'Առողջություն / հանրային անվտանգություն', 'Արդարադատություն', 'Կենսակերպ / մշակույթ', 'Քաղաքականություն', 'Հասարակություն', 'Սպորտ', 'Տեխնոլոգիա / գիտություն', 'Աշխարհ']
      cat_en.each_with_index do |cat, index|
        puts "- #{cat}"
        trans = CategoryTranslation.where(locale: 'en', name: cat).first
        if trans.present?
          new_trans = trans.dup
          new_trans.locale = locale
          new_trans.name = cat_hy[index]
          new_trans.save
        else
          puts "**** could not find category with name #{cat}"
          raise ActiveRecord::Rollback
          return
        end
      end

      # idea status
      puts "IDEA STATUS"
      idea_en = ['Chosen', 'Data Requested', 'Data Received', 'Analysing Data', 'Designing', 'Waiting for Pub', 'Published', 'Cancelled']
      idea_hy = ['Ընտրված', 'Հայցված տվյալներ', 'Ստացված տվյալներ', 'Տվյալների վերլուծություն', 'Ձևավորում', 'Սպասում է հրապարակման', 'Հրապարակված է', 'Չեղարկված է']
      idea_en.each_with_index do |idea, index|
        puts "- #{idea}"
        trans = IdeaStatusTranslation.where(locale: 'en', name: idea).first
        if trans.present?
          new_trans = trans.dup
          new_trans.locale = locale
          new_trans.name = cat_hy[index]
          new_trans.save
        else
          puts "**** could not find idea status with name #{cat}"
          raise ActiveRecord::Rollback
          return
        end
      end

      # organizations
      puts "ORGANIZATIONS"
      OrganizationTranslation.where(locale: 'en').each do |trans|
        puts "- #{trans.name}"
        new_trans = trans.dup
        new_trans.locale = locale
        new_trans.permalink = nil
        new_trans.save
      end
    end
  end

  def down
    locale = 'hy'
    CategoryTranslation.transaction do
      CategoryTranslation.where(locale: locale).destroy_all
      IdeaStatusTranslation.where(locale: locale).destroy_all
      OrgranizationTranslation.where(locale: locale).destroy_all
    end
  end
end
