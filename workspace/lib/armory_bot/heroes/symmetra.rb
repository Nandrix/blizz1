module ArmoryBot
  module Commands
    module Symmetra
      extend Discordrb::Commands::CommandContainer
      command([:symmetra, :Symmetra, :SYMMETRA], bucket: :overwatch, min_args: 4, rate_limit_message: 'All heroes share a rate limit. Wait %time% more seconds.') do |event, *account, region, platform, mode|

        platform = platform.downcase

        mode = mode.downcase

        acc = account.join(' ')

        if platform == "pc"
          acc = acc.split('#')
          acc = acc.join('-')
        elsif platform == "xbl"
          acc = acc.split(' ')
          acc = acc.join('%20')
        else
          acc = acc.downcase
        end

        if platform == "pc" && region == "us"
          region = "us"
        elsif platform == "pc" && region =="eu"
          region = "eu"
        elsif platform == "psn" || platform == "xbl"
          region = "global"
        else
          nil
        end

        data1 = HTTParty.get("https://api.lootbox.eu/#{platform}/#{region}/#{acc}/quick-play/hero/Symmetra/", :verify => false ).parsed_response
        data2 = HTTParty.get("https://api.lootbox.eu/#{platform}/#{region}/#{acc}/competitive-play/hero/Symmetra/", :verify => false ).parsed_response

        break unless mode == "qp" || mode == "cp"

        if mode == nil || mode == "qp"
          data = data1["Symmetra"]
          type = "Quick Play"
        elsif mode == "cp"
          data = data2["Symmetra"]
          type = "Competitive Play"
        else
          nil
        end

        if platform == "pc"
          name = account.first
        else
          name = acc.split('%20')
          name = name.join(' ')
        end

        turrets = data["SentryTurretKills"]
        turrets_most = data["SentryTurretKills-MostinGame"]
        turrets_average = data["SentryTurretKills-Average"]
        teleported = data["PlayersTeleported"]
        teleported_average = data["PlayersTeleported-Average"]
        teleported_most = data["PlayersTeleported-MostinGame"]
        tp_uptime = data["TeleporterUptime"]
        tp_uptime_average = data["TeleporterUptime-Average"]
        tp_uptime_most = data["TeleporterUptime-MostinGame"]
        shields = data["ShieldsProvided"]
        shields_average = data["ShieldsProvided-Average"]
        shields_most = data["ShieldsProvided-MostinGame"]

        elims = data["Eliminations"]
        objk = data["ObjectiveKills"]
        objt = data["ObjectiveTime"]
        dmg = data["DamageDone"]
        wacc = data["WeaponAccuracy"]
        ksm = data["KillStreak-Best"]
        dmgm = data["DamageDone-MostinGame"]
        elimsm = data["Eliminations-MostinGame"]
        objkm = data["ObjectiveKills-MostinGame"]
        objtm = data["ObjectiveTime-MostinGame"]
        deathsavg = data["Deaths-Average"]
        objtavg = data["ObjectiveTime-Average"]
        objkavg = data["ObjectiveKills-Average"]
        elimsavg = data["Eliminations-Average"]
        solokill = data["SoloKills"]
        solokillavg = data["SoloKills-Average"]
        dmgavg = data["DamageDone-Average"]
        deaths = data["Deaths"]
        bmedals = data["Medals-Bronze"]
        smedals = data["Medals-Silver"]
        gmedals = data["Medals-Gold"]
        playedt = data["TimePlayed"]
        gplayed = data["GamesPlayed"]
        gwon = data["GamesWon"]
        winperc = data["WinPercentage"]
        cards = data["Cards"]

        if data["statusCode"] == 500
          event << "Sorry, you inputted everything correctly, just seems to be an error while retrieving your account. :( "
        elsif data["statusCode"] == 404
          event << "Sorry, no account was found with that name."
        else
          event.respond """#{event.user.mention} - #{name.capitalize} - Symmetra - #{type}
```ruby
- Hero Specific -
Sentry Turret Kills: #{turrets} | Most in Game: #{turrets_most} | Average: #{turrets_average}
Shields Provided: #{shields} | Most in Game: #{shields_most} | Average: #{shields_average}
Players Teleported: #{teleported} | Most in Game: #{teleported_most} | Average: #{teleported_average}
Teleporter Uptime: #{tp_uptime} | Most in Game: #{tp_uptime_most} | Average: #{tp_uptime_average}

- Total Stats -
Eliminations: #{elims} | Damage Done: #{dmg} | Deaths: #{deaths}
Objective Kills: #{objk} | Best Killstreak: #{ksm} | Solo Kills: #{solokill}

- Average Stats -
Eliminations: #{elimsavg} | Damage Done: #{dmgavg} | Deaths: #{deathsavg}
Objective Kills: #{objkavg} | Objective Time: #{objtavg} | Solo Kills: #{solokillavg}

- Game -
Time Played: #{playedt} | Games Won: #{gwon} | Win Percentage: #{winperc}
Gold: #{gmedals} | Silver: #{smedals} | Bronze: #{bmedals} | Cards: #{cards}
```"""
        end
        puts "#{event.server.name} - Symmetra"
      end
    end
  end
end