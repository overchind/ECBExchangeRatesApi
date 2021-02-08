# ECBExchangeRatesApi

This is an unofficial wrapper for the awesome, free ExchangeRatesAPI, which provides exchange rate lookups courtesy of the European Central Bank.

[![Gem Version](https://badge.fury.io/rb/ecb_exchange_rates_api.svg)](https://badge.fury.io/rb/ecb_exchange_rates_api.svg)
[![Build Status](https://travis-ci.com/overchind/ECBExchangeRatesApi.svg?branch=master)](https://travis-ci.com/overchind/ECBExchangeRatesApi)
## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ecb_exchange_rates_api'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install ecb_exchange_rates_api

## Getting Started

Since the CurrencyExchangeAPI does not require API keys or authentication in order to access and interrogate its API, getting started with this library is easy. The following examples show how to achieve various functions using the library.

### Basic usage:

Fetch the latest exchange rates from the European Central Bank:

```ruby
client = ECBExchangeRatesApi::Client.new 
client.fetch
```

### Historical data:

Get historical rates for any day since 1999:

```ruby
client.at("2010-09-21").fetch
```

or specify some date range:

```ruby
client.from("2010-09-21").to("2010-10-21").fetch
```

### Set the base currency:

By default, the base currency is set to Euro (EUR), but it can be changed:

```ruby
client.with_base("USD").fetch
```

currency code should be passed as an ISO 4217 code.

### Fetch specific rates:
If you do not want all current rates, it's possible to specify only the currencies you want using with `for_rate(symbol)` or `for_rates(array_of_symbols)`. The following code fetches only the exchange rate between GBP and EUR:

```ruby
client.with_base("GBP").for_rate("EUR").fetch
```

### Convert

It is useful not just to check the exchange rates but also to calculate the amount of money for them. This is the case where the `convert` method comes into play. You can specify options with the method arguments `convert(amount, base, symbols, specific_data)` or use the preconfigured client as follow:

```ruby
client.convert(100, "USD", %w(EUR SEK), "2018-02-01")
#or
base_client = ECBExchangeRatesApi::Client.new do |c|
  c.with_base "USD"
  c.for_rates %w(EUR SEK)
  c.at "2018-02-01"
end
base_client.convert(100)
```

Please refer to the [API website](https://exchangeratesapi.io/) for further information and full API docs.

### Supported Currencies:

The library supports any currency currently available on the European Central Bank's web service, which at the time of the latest release are as follows:

![](https://www.ecb.europa.eu/shared/img/flags/AUD.gif) Australian Dollar (AUD)<br />
![](https://www.ecb.europa.eu/shared/img/flags/BRL.gif) Brazilian Real (BRL)<br />
![](https://www.ecb.europa.eu/shared/img/flags/GBP.gif) British Pound Sterline (GBP)<br />
![](https://www.ecb.europa.eu/shared/img/flags/BGN.gif) Bulgarian Lev (BGN)<br />
![](https://www.ecb.europa.eu/shared/img/flags/CAD.gif) Canadian Dollar (CAD)<br />
![](https://www.ecb.europa.eu/shared/img/flags/CNY.gif) Chinese Yuan Renminbi (CNY)<br />
![](https://www.ecb.europa.eu/shared/img/flags/HRK.gif) Croatian Kuna (HRK)<br />
![](https://www.ecb.europa.eu/shared/img/flags/CZK.gif) Czech Koruna (CZK)<br />
![](https://www.ecb.europa.eu/shared/img/flags/DKK.gif) Danish Krone (DKK)<br />
![](https://www.ecb.europa.eu/shared/img/flags/EUR.gif) Euro (EUR)<br />
![](https://www.ecb.europa.eu/shared/img/flags/HKD.gif) Hong Kong Dollar (HKD)<br />
![](https://www.ecb.europa.eu/shared/img/flags/HUF.gif) Hungarian Forint (HUF)<br />
![](https://www.ecb.europa.eu/shared/img/flags/ISK.gif) Icelandic Krona (ISK)<br />
![](https://www.ecb.europa.eu/shared/img/flags/IDR.gif) Indonesian Rupiah (IDR)<br />
![](https://www.ecb.europa.eu/shared/img/flags/INR.gif) Indian Rupee (INR)<br />
![](https://www.ecb.europa.eu/shared/img/flags/ILS.gif) Israeli Shekel (ILS)<br />
![](https://www.ecb.europa.eu/shared/img/flags/JPY.gif) Japanese Yen (JPY)<br />
![](https://www.ecb.europa.eu/shared/img/flags/MYR.gif) Malaysian Ringgit (MYR)<br />
![](https://www.ecb.europa.eu/shared/img/flags/MXN.gif) Mexican Peso (MXN)<br />
![](https://www.ecb.europa.eu/shared/img/flags/NZD.gif) New Zealand Dollar (NZD)<br />
![](https://www.ecb.europa.eu/shared/img/flags/NOK.gif) Norwegian Krone (NOK)<br />
![](https://www.ecb.europa.eu/shared/img/flags/PHP.gif) Philippine Peso (PHP)<br />
![](https://www.ecb.europa.eu/shared/img/flags/PLN.gif) Polish Zloty (PLN)<br />
![](https://www.ecb.europa.eu/shared/img/flags/RON.gif) Romanian Leu (RON)<br />
![](https://www.ecb.europa.eu/shared/img/flags/RUB.gif) Russian Rouble (RUB)<br />
![](https://www.ecb.europa.eu/shared/img/flags/SGD.gif) Singapore Dollar (SGD)<br />
![](https://www.ecb.europa.eu/shared/img/flags/ZAR.gif) South African Rand (ZAR)<br />
![](https://www.ecb.europa.eu/shared/img/flags/KRW.gif) South Korean Won (KRW)<br />
![](https://www.ecb.europa.eu/shared/img/flags/SEK.gif) Swedish Krona (SEK)<br />
![](https://www.ecb.europa.eu/shared/img/flags/CHF.gif) Swiss Franc (CHF)<br />
![](https://www.ecb.europa.eu/shared/img/flags/THB.gif) Thai Baht (THB)<br />
![](https://www.ecb.europa.eu/shared/img/flags/TRY.gif) Turkish Lira (TRY)<br />
![](https://www.ecb.europa.eu/shared/img/flags/USD.gif) US Dollar (USD)<br />

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/overchind/ECBExchangeRatesApi. This project is intended to be a safe, welcoming space for collaboration.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
