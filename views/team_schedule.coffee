React = require 'react/addons'
moment = require 'moment'
_ = require 'lodash'

Teams = require '../lib/teams'

moment.locale('fi'
  months : [
    "Tammikuu", "Helmikuu", "Maaliskuu", "Huhtikuu", "Toukokuu", "Kesäkuu", "Heinäkuu",
    "Elokuu", "Syyskuu", "Lokakuu", "Marraskuu", "Joulukuu"
  ]
)
moment.locale('fi')

TeamSchedule = React.createClass

  matchLink: (match) ->
    if moment(match.date) < moment()
      <a href="/ottelut/#{match.id}">{@titleStyle(match.home)} - {@titleStyle(match.away)}</a>
    else
      <span>{@titleStyle(match.home)} - {@titleStyle(match.away)}</span>

  titleStyle: (name) ->
    if @props.team.info.name is name
      <strong>{name}</strong>
    else
      name

  logo: (name) ->
    <img src={Teams.logo(name)} alt={name} />

  groupedSchedule: ->
    _.chain(@props.team.schedule).groupBy (match) ->
      moment(match.date).format("YYYY-MM")

  render: ->
    monthlyMatches = @groupedSchedule().map (matches, month) =>
      <tbody key={month}>
        <tr>
          <th colSpan=4>{moment(month, "YYYY-MM").format("MMMM")}</th>
        </tr>
        {matches.map (match) =>
          <tr key={match.id}>
            <td>{moment(match.date).format("DD.MM.YYYY")} {match.time}</td>
            <td>{@matchLink(match)}</td>
            <td>{match.homeScore}-{match.awayScore}</td>
            <td>{match.attendance}</td>
          </tr>
        }
      </tbody>

    <div className="table-responsive">
      <table className="table table-striped team-schedule">
        <thead>
          <tr>
            <th>Päivämäärä</th>
            <th>Joukkueet</th>
            <th>Tulos</th>
            <th>Yleisömäärä</th>
          </tr>
        </thead>
        {monthlyMatches}
      </table>
    </div>

module.exports = TeamSchedule