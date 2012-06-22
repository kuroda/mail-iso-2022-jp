# coding: utf-8

$:.unshift File.dirname(__FILE__)
require 'test_helper'
require File.dirname(__FILE__) + '/../init'

class MailTest < ActiveSupport::TestCase
  test "should send with ISO-2022-JP encoding" do
    mail = Mail.new(:charset => 'ISO-2022-JP') do
      from '山田太郎 <taro@example.com>'
      sender 'X事務局 <info@example.com>'
      reply_to 'X事務局 <info@example.com>'
      to '佐藤花子 <hanako@example.com>'
      cc 'X事務局 <info@example.com>'
      resent_from '山田太郎 <taro@example.com>'
      resent_sender 'X事務局 <info@example.com>'
      resent_to '佐藤花子 <hanako@example.com>'
      resent_cc 'X事務局 <info@example.com>'
      subject '日本語 件名'
      body '日本語本文'
    end
    assert_equal 'ISO-2022-JP', mail.charset
    assert_equal NKF::JIS, NKF.guess(mail.subject)
    assert_equal "From: =?ISO-2022-JP?B?GyRCOzNFREJATzobKEI=?= <taro@example.com>\r\n", mail[:from].encoded
    assert_equal "Sender: =?ISO-2022-JP?B?WBskQjt2TDM2SRsoQg==?= <info@example.com>\r\n", mail[:sender].encoded
    assert_equal "Reply-To: =?ISO-2022-JP?B?WBskQjt2TDM2SRsoQg==?= <info@example.com>\r\n", mail[:reply_to].encoded
    assert_equal "To: =?ISO-2022-JP?B?GyRCOjRGIzJWO1IbKEI=?= <hanako@example.com>\r\n", mail[:to].encoded
    assert_equal "Cc: =?ISO-2022-JP?B?WBskQjt2TDM2SRsoQg==?= <info@example.com>\r\n", mail[:cc].encoded
    assert_equal "Resent-From: =?ISO-2022-JP?B?GyRCOzNFREJATzobKEI=?= <taro@example.com>\r\n", mail[:resent_from].encoded
    assert_equal "Resent-Sender: =?ISO-2022-JP?B?WBskQjt2TDM2SRsoQg==?= <info@example.com>\r\n", mail[:resent_sender].encoded
    assert_equal "Resent-To: =?ISO-2022-JP?B?GyRCOjRGIzJWO1IbKEI=?= <hanako@example.com>\r\n", mail[:resent_to].encoded
    assert_equal "Resent-Cc: =?ISO-2022-JP?B?WBskQjt2TDM2SRsoQg==?= <info@example.com>\r\n", mail[:resent_cc].encoded
    assert_equal "Subject: =?ISO-2022-JP?B?GyRCRnxLXDhsGyhCIBskQjdvTD4bKEI=\?=\r\n", mail[:subject].encoded
    assert_equal NKF::JIS, NKF.guess(mail.body.encoded)
  end

  test "should send with UTF-8 encoding" do
    mail = Mail.new do
      from '山田太郎 <taro@example.com>'
      to '佐藤花子 <hanako@example.com>'
      cc '事務局 <info@example.com>'
      subject '日本語件名'
      body '日本語本文'
    end
    assert_equal 'UTF-8', mail.charset
    assert_equal NKF::UTF8, NKF.guess(mail.subject)
    assert_equal "From: =?UTF-8?B?5bGx55Sw5aSq6YOO?= <taro@example.com>\r\n", mail[:from].encoded
    assert_equal "To: =?UTF-8?B?5L2Q6Jek6Iqx5a2Q?= <hanako@example.com>\r\n", mail[:to].encoded
    assert_equal "Cc: =?UTF-8?B?5LqL5YuZ5bGA?= <info@example.com>\r\n", mail[:cc].encoded
    assert_equal "Subject: =?UTF-8?Q?=E6=97=A5=E6=9C=AC=E8=AA=9E=E4=BB=B6=E5=90=8D?=\r\n", mail[:subject].encoded
    assert_equal NKF::UTF8, NKF.guess(mail.body.encoded)
  end

  test "should handle array correctly" do
    mail = Mail.new(:charset => 'ISO-2022-JP') do
      from [ '山田太郎 <taro@example.com>', '山田次郎 <jiro@example.com>' ]
      to [ '佐藤花子 <hanako@example.com>', '佐藤好子 <yoshiko@example.com>' ]
      cc [ 'X事務局 <info@example.com>',  '事務局長 <boss@example.com>' ]
      subject '日本語件名'
      body '日本語本文'
    end
    assert_equal "From: =?ISO-2022-JP?B?GyRCOzNFREJATzobKEI=?= <taro@example.com>, \r\n =?ISO-2022-JP?B?GyRCOzNFRDwhTzobKEI=?= <jiro@example.com>\r\n", mail[:from].encoded
    assert_equal "To: =?ISO-2022-JP?B?GyRCOjRGIzJWO1IbKEI=?= <hanako@example.com>, \r\n =?ISO-2022-JP?B?GyRCOjRGIzklO1IbKEI=?= <yoshiko@example.com>\r\n", mail[:to].encoded
    assert_equal "Cc: =?ISO-2022-JP?B?WBskQjt2TDM2SRsoQg==?= <info@example.com>, \r\n =?ISO-2022-JP?B?GyRCO3ZMMzZJRDkbKEI=?= <boss@example.com>\r\n", mail[:cc].encoded
  end

  if RUBY_VERSION >= '1.9'
    test "should raise exeception if the encoding of subject is not UTF-8" do
      assert_raise Mail::InvalidEncodingError do
        Mail.new(:charset => 'ISO-2022-JP') do
          from [ '山田太郎 <taro@example.com>' ]
          to [ '佐藤花子 <hanako@example.com>' ]
          subject NKF.nkf("-Wj", '日本語 件名')
          body '日本語本文'
        end
      end
    end

    test "should raise exeception if the encoding of mail body is not UTF-8" do
      assert_raise Mail::InvalidEncodingError do
        Mail.new(:charset => 'ISO-2022-JP') do
          from [ '山田太郎 <taro@example.com>' ]
          to [ '佐藤花子 <hanako@example.com>' ]
          subject '日本語件名'
          body NKF.nkf("-Wj", '日本語本文')
        end
      end
    end
  end

  # The thunderbird handle them like this.
  test "should handle fullwidth tildes and wave dashes correctly" do
    fullwidth_tilde = "～"
    assert_equal [0xef, 0xbd, 0x9e], fullwidth_tilde.unpack("C*")
    wave_dash = "〜"
    assert_equal [0xe3, 0x80, 0x9c], wave_dash.unpack("C*")

    text1 = "#{fullwidth_tilde}#{wave_dash}"
    text2 = "#{wave_dash}#{wave_dash}"

    mail = Mail.new(:charset => 'ISO-2022-JP') do
      from 'taro@example.com'
      to 'hanako@example.com'
      subject text1
      body text1
    end

    assert_equal "Subject: #{text2}\r\n", NKF.nkf('-mw', mail[:subject].encoded)
    assert_equal text2, NKF.nkf('-w', mail.body.encoded)
  end

  test "should handle numbers in circle correctly" do
    text = "①②③④⑤⑥⑦⑧⑨"

    mail = Mail.new(:charset => 'ISO-2022-JP') do
      from 'taro@example.com'
      to 'hanako@example.com'
      subject text
      body text
    end

    assert_equal "Subject: #{text}\r\n", NKF.nkf('-mw', mail[:subject].encoded)
    assert_equal text, NKF.nkf('-w', mail.body.encoded)
  end

  test "should handle 'hashigodaka' and 'tatsusaki' correctly" do
    text = "髙﨑"

    mail = Mail.new(:charset => 'ISO-2022-JP') do
      from 'taro@example.com'
      to 'hanako@example.com'
      subject text
      body text
    end

    assert_equal "Subject: #{text}\r\n", NKF.nkf('-mw', mail[:subject].encoded)
    assert_equal "Subject: =?ISO-2022-JP?B?GyRCfGJ5dRsoQg==?=\r\n", mail[:subject].encoded
    assert_equal text, NKF.nkf('-w', mail.body.encoded)

    if RUBY_VERSION >= '1.9'
      assert_equal NKF.nkf('--oc=CP50220 -j', text).force_encoding('ascii-8bit'),
        mail.body.encoded.force_encoding('ascii-8bit')
    else
      assert_equal NKF.nkf('--oc=CP50220 -j', text), mail.body.encoded
    end
  end

  test "should handle hankaku kana correctly" do
    text = "ｱｲｳｴｵ"

    mail = Mail.new(:charset => 'ISO-2022-JP') do
      from 'taro@example.com'
      to 'hanako@example.com'
      subject text
      body text
    end

    assert_equal "Subject: #{text}\r\n", NKF.nkf('-mxw', mail[:subject].encoded)
    assert_equal text, NKF.nkf('-xw', mail.body.encoded)
  end

  test "should handle frozen texts correctly" do
    mail = Mail.new(:charset => 'ISO-2022-JP') do
      from 'taro@example.com'
      to 'hanako@example.com'
      subject "text".freeze
      body "text".freeze
    end

    assert_equal "Subject: text\r\n", NKF.nkf('-mxw', mail[:subject].encoded)
    assert_equal "text", NKF.nkf('-xw', mail.body.encoded)
  end

  test "should convert ibm special characters correctly" do
    text = "髙﨑"
    j = NKF.nkf('--oc=CP50220 -j', text)
    assert_equal "GyRCfGJ5dRsoQg==", Base64.encode64(j).gsub("\n", "")
  end

  test "should convert wave dash to zenkaku" do
    fullwidth_tilde = "～"
    assert_equal [0xef, 0xbd, 0x9e], fullwidth_tilde.unpack("C*")
    wave_dash = "〜"
    assert_equal [0xe3, 0x80, 0x9c], wave_dash.unpack("C*")

    j = NKF.nkf('--oc=CP50220 -j', fullwidth_tilde)
    assert_equal wave_dash, NKF.nkf("-w", j)
  end

  test "should keep hankaku kana as is" do
    text = "ｱｲｳｴｵ"
    j = NKF.nkf('--oc=CP50220 -x -j', text)
    e = Base64.encode64(j).gsub("\n", "")
    assert_equal "GyhJMTIzNDUbKEI=", e
    assert_equal "ｱｲｳｴｵ", NKF.nkf("-xw", j)
  end
end
