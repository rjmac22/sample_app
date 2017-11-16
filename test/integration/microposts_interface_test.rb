require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest

    def setup
        @user = users(:michael)
    end

    test "micropost interface" do
        log_in_as(@user)
        get root_path
        assert_select 'div.pagination'
        assert_select 'input[type=file]'
        # Invalid submission
        assert_no_difference 'Micropost.count' do
            post microposts_path, params: { micropost: { content: ""} }
        end
        assert_select 'div#error_explanation'
        # Valid submission
        content = "this micropost really ties the room together"
        picture = fixture_file_upload('test/fixture/rails.png', 'image/png')
        assert_difference 'Micropost.count', 1 do
            post microposts_path, params: { micropost: { content: content, picture: picture } }
        end
        foo = assigns(:micropost)
        assert foo.picture?
        assert_redirected_to root_url
        follow_redirect!
        assert_match content, response.body
        # Delete Post
        assert_select 'a', text: 'delete'
        first_micropost = @user.microposts.paginate(page: 1).first
        assert_difference 'Micropost.count', -1 do
            delete micropost_path(first_micropost)
        end
        # Visit different user (no dlete links)
        get user_path(users(:archer))
        assert_select 'a', text: 'delete', count: 0
    end


    test "micopast sidebar count" do
        log_in_as(@user)
        get root_path
        assert_match "#{@user.microposts.count} microposts", response.body

        # User with zero microposts
        other_user = users(:malory)
        log_in_as(other_user)
        get root_path
        assert_match "0 microposts", response.body
        other_user.microposts.create!(content: "A micropost")
        get root_path
        assert_match "1 micropost", response.body
    end


end
