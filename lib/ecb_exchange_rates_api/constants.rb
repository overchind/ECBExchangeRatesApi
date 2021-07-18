# frozen_string_literal: true

module ECBExchangeRatesApi
  module Constants
    API_URL = "api.exchangeratesapi.io"

    DEFAULT_BASE = "EUR"
    CURRENCIES = %w[AED AFN ALL AMD ANG AOA ARS AUD AWG AZN
                    BAM BBD BDT BGN BHD BIF BMD BND BOB BRL
                    BSD BTC BTN BWP BYN BYR BZD CAD CDF CHF
                    CLF CLP CNY COP CRC CUC CUP CVE CZK DJF
                    DKK DOP DZD EGP ERN ETB EUR FJD FKP GBP
                    GEL GGP GHS GIP GMD GNF GTQ GYD HKD HNL
                    HRK HTG HUF IDR ILS IMP INR IQD IRR ISK
                    JEP JMD JOD JPY KES KGS KHR KMF KPW KRW
                    KWD KYD KZT LAK LBP LKR LRD LSL LTL LVL
                    LYD MAD MDL MGA MKD MMK MNT MOP MRO MUR
                    MVR MWK MXN MYR MZN NAD NGN NIO NOK NPR
                    NZD OMR PAB PEN PGK PHP PKR PLN PYG QAR
                    RON RSD RUB RWF SAR SBD SCR SDG SEK SGD
                    SHP SLL SOS SRD STD SVC SYP SZL THB TJS
                    TMT TND TOP TRY TTD TWD TZS UAH UGX USD
                    UYU UZS VEF VND VUV WST XAF XAG XAU XCD
                    XDR XOF XPF YER ZAR ZMK ZMW ZWL].freeze

    CURRENCY_REGEXP = /^[A-Z]{3}$/.freeze

    # rubocop:disable Metrics/LineLength
    DATE_REGEXP = /^[0-9]{4}-((([13578]|0[13578]|(10|12))-([1-9]|0[1-9]|[1-2][0-9]|3[0-1]))|(02-(0[1-9]|[1-2][0-9]))|(([469]|0[469]|11)-([1-9]|0[1-9]|[1-2][0-9]|30)))$/.freeze
    # rubocop:enable Metrics/LineLength
  end
end
