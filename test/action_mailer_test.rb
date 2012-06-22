# coding: utf-8

$:.unshift File.dirname(__FILE__)
require 'test_helper'
require 'action_mailer'
require File.dirname(__FILE__) + '/../init'

class ActionMailerTest < ActiveSupport::TestCase
  test "should send with ISO-2022-JP encoding" do
    mail = Iso2022jpMailer.notice
    assert_equal NKF::JIS, NKF.guess(mail.subject)
    assert_equal "From: =?ISO-2022-JP?B?GyRCOzNFREJATzobKEI=?= <taro@example.com>\r\n", mail[:from].encoded
    assert_equal "To: =?ISO-2022-JP?B?GyRCOjRGIzJWO1IbKEI=?= <hanako@example.com>\r\n", mail[:to].encoded
    assert_equal "Cc: =?ISO-2022-JP?B?GyRCO3ZMMzZJGyhC?= <info@example.com>\r\n", mail[:cc].encoded
    assert_equal "Subject: =?ISO-2022-JP?B?GyRCRnxLXDhsGyhCIBskQjdvTD4bKEI=\?=\r\n", mail[:subject].encoded
    assert_equal NKF::JIS, NKF.guess(mail.body.encoded)
  end

  test "should send with UTF-8 encoding" do
    mail = OriginMailer.notice
    assert_equal NKF::UTF8, NKF.guess(mail.subject)
    assert_equal "From: =?UTF-8?B?5bGx55Sw5aSq6YOO?= <taro@example.com>\r\n", mail[:from].encoded
    assert_equal "To: =?UTF-8?B?5L2Q6Jek6Iqx5a2Q?= <hanako@example.com>\r\n", mail[:to].encoded
    assert_equal "Cc: =?UTF-8?B?5LqL5YuZ5bGA?= <info@example.com>\r\n", mail[:cc].encoded
    assert_equal "Subject: =?UTF-8?Q?=E6=97=A5=E6=9C=AC=E8=AA=9E=E4=BB=B6=E5=90=8D?=\r\n", mail[:subject].encoded
    assert_equal NKF::UTF8, NKF.guess(mail.body.encoded)
  end

  test "should handle array correctly" do
    mail = Iso2022jpMailer.notice2
    assert_equal NKF::JIS, NKF.guess(mail.subject)
    assert_equal "From: =?ISO-2022-JP?B?GyRCOzNFREJATzobKEI=?= <taro@example.com>\r\n", mail[:from].encoded
    assert_equal "To: =?ISO-2022-JP?B?GyRCOjRGIzJWO1IbKEI=?= <hanako@example.com>, \r\n =?ISO-2022-JP?B?GyRCOjRGIzklO1IbKEI=?= <yoshiko@example.com>\r\n", mail[:to].encoded
    assert_equal "Cc: =?ISO-2022-JP?B?GyRCO3ZMMzZJGyhC?= <info@example.com>\r\n", mail[:cc].encoded
    assert_equal "Subject: =?ISO-2022-JP?B?GyRCRnxLXDhsGyhCIBskQjdvTD4bKEI=\?=\r\n", mail[:subject].encoded
    assert_equal NKF::JIS, NKF.guess(mail.body.encoded)
  end

  test "should handle a received mail correctly" do
    eml = File.open(File.dirname(__FILE__) + '/data/sample0.eml').read
    mail = Iso2022jpMailer.receive(eml)
    assert_equal NKF::JIS, NKF.guess(mail.body.decoded)
    assert_equal "投稿テスト\n--\nyamada@example.jp", NKF.nkf("-Jw", mail.body.decoded)
  end
end

class Iso2022jpMailer < ActionMailer::Base
  default :charset => 'ISO-2022-JP',
    :from => "山田太郎 <taro@example.com>",
    :cc => "事務局 <info@example.com>"

  def notice
    mail(:to => '佐藤花子 <hanako@example.com>', :subject => '日本語 件名') do |format|
      format.text { render :inline => '日本語本文' }
    end
  end

  def notice2
    mail(:to => [ '佐藤花子 <hanako@example.com>', '佐藤好子 <yoshiko@example.com>' ], :subject => '日本語 件名') do |format|
      format.text { render :inline => '日本語本文' }
    end
  end

  def receive(eml)
    eml
  end
end

class OriginMailer < ActionMailer::Base
  default :from => "山田太郎 <taro@example.com>",
    :cc => "事務局 <info@example.com>"

  def notice
    mail(:to => '佐藤花子 <hanako@example.com>', :subject => '日本語件名') do |format|
      format.text { render :inline => '日本語本文' }
    end
  end
end
