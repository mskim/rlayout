module RLayout

  class NewsIssuePlan
    attr_reader :publication_path, :date, :issue_path, :issue_number

    def initialize(options={})
      @publication_path = options[:publication_path]
      @date = options[:date]
      @issue_number = options[:issue_number] || 1000
      @issue_path = @publication_path + "/#{@date}"
      FileUtils.mkdir(@issue_path) unless File.exist?(@issue_path)
      load_issue_plan
      create_page_md_files
      parse_page_md_files
      build_pages
      self
    end

    def create_page_md_files
      @issue_plan['pages'].each_with_index do |page_info, i|
        page_md_path = @issue_path + "/page_#{(i+1).to_s.rjust(2,'0')}.md"
        save_page_md(page_info, page_md_path)
      end
    end

    def parse_page_md_files
      @issue_plan['pages'].each_with_index do |page_info, i|
        page_md_path = @issue_path + "/page_#{(i+1).to_s.rjust(2,'0')}.md"
        RLayout::NewsPageParser.new(page_md_path)
      end
    end

    def build_pages
      @issue_plan['pages'].each_with_index do |page_info, i|
        page_path = @issue_path + "/page_#{(i+1).to_s.rjust(2,'0')}"
        RLayout::NewsPageBuilder.new(page_path)
      end
    end

    def page_heading
      <<~EOF

      ---

      page_number: #{@page_number}
      section_name: #{@section_name}
      issue_number: #{@issue_number}
      ad_type: #{@ad_type}
      advertiser: #{@advertiser}

      ---

      EOF
    end

    def save_page_md(page_info, page_md_path)
      pillars = page_info[:pillars] || page_info['pillars']
      @issue_number = page_info[:issue_number] || page_info['issue_number']
      @page_number = page_info[:page_number] || page_info['page_number']
      @section_name = page_info[:section_name] || page_info['section_name']
      @ad_type = page_info[:ad_type] || page_info['ad_type']
      @advertiser = page_info[:advertiser] || page_info['advertiser']
      page_md_content = page_heading
      if pillars && pillars.length > 0
        pillars.each do |pillar_array|
          # pillar_column = pillar_array[0]
          article_count = pillar_array[1]
          page_md_content += sample_pillar_article_of(article_count)
        end
      else
        # when full page ad
      end
      
      File.open(page_md_path, 'w'){|f| f.write page_md_content}
    end

    def issue_plan_path
      @issue_path + "/issue_plan.yml"
    end

    def load_issue_plan
      if File.exist?(issue_plan_path)
        @issue_plan = YAML::load_file(issue_plan_path)
      else
        @issue_plan = YAML::load(default_issue_plan)
        File.open(issue_plan_path, 'w'){|f| f.write default_issue_plan}
      end
    end

    def default_issue_plan
      <<~EOF

      ---
      date: #{@date}
      issue_number: #{@issue_number}
      pages:
      - page_number: 1
        section_name: 1면
        pillars: [[4,2], [2,3]]
        ad_type: 5단통
        advertiser: 삼성전자
      - page_number: 2
        section_name: 소식
        pillars: [[2,3], [2,3], [2,3]]
      - page_number: 3
        section_name: 소식
        pillars: [[2,3], [2,3], [2,3]]
      - page_number: 4
        section_name: 전면광고
        ad_type: 15단통
        advertiser: LG전자

      EOF
    end

    def sample_pillar_article_of(count)
      content = "\npillar\n\n"
      count.times do
        content += sample_article
      end
      content += "\n\n"
      content
    end

    def sample_article
      <<~EOF

      # article

      ---
      title: 여기는 기사 제목 입니다.
      subtitle: 여기는 기사 부제목 입니다.
      reporter: 홍길동

      ---

      여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 
      여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 

      여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 
      여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 

      여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 
      여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 

      EOF

    end

    def self.sample_article_english
      <<~EOF

      # article

      ---
      title: Article title goes here.
      subtitle: Book Subitle Here
      reporter: Gil Dong Hong

      ---

      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. 

      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. 

      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. 

      EOF

    end

  end
end