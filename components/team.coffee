React = require 'react'
{TabPane, Jumbotron, ButtonToolbar, Button, Col, Row, Nav, NavItem} = require "react-bootstrap"

Teams = require '../lib/teams'

TeamSchedule = require './team/team_schedule'
TeamStats = require './team/team_stats'
TeamRoster = require './team/team_roster'
Navigation = require './shared/navigation'

Team = React.createClass

  statics:
    title: (props, request) ->
      subTitle = switch request.params.active
        when "pelaajat" then "Pelaajat"
        when "tilastot" then "Tilastot"
        else "Otteluohjelma"

      "Joukkueet - #{props.team.info?.name} - #{subTitle}"

    stores: (request) ->
      standings: {}
      team: {id: request.params.id}

    preprocess: (props, request) ->
      props.id = request.params.id
      props.active = request.params.active
      props

  componentDidMount: ->
    window.scrollTo(0,0)

  logo: ->
    <img src={Teams.logo(@props.team.info.name)} alt={@props.team.info.name} />

  render: ->
    activeKey = switch @props.active
      when "pelaajat" then "players"
      when "tilastot" then "stats"
      else "schedule"

    team = @props.team or {}
    teamInfo = team.info or {}

    <div>
      <Navigation />

      <div className="team">
        <Jumbotron>
          <Row>
            <Col xs={12} md={6}>
              <h1>{if team.info then @logo() else ""} {teamInfo.name}</h1>
            </Col>
            <Col xs={12} md={6}>
              <div className="team-container">
                <ul>
                  <li>{teamInfo.longName}</li>
                  <li>{teamInfo.address}</li>
                  <li>{teamInfo.email}</li>
                </ul>

                <ButtonToolbar>
                  <Button bsStyle="primary" bsSize="large" href={teamInfo.ticketsUrl}>Liput</Button>
                  <Button bsStyle="primary" bsSize="large" href={teamInfo.locationUrl}>Hallin sijainti</Button>
                </ButtonToolbar>
              </div>
            </Col>
          </Row>
        </Jumbotron>

        <div>
          <Nav bsStyle="tabs" activeKey={activeKey} ref="tabs">
            <NavItem href="/joukkueet/#{@props.id}" eventKey="schedule">Ottelut</NavItem>
            <NavItem href="/joukkueet/#{@props.id}/tilastot" eventKey="stats">Tilastot</NavItem>
            <NavItem href="/joukkueet/#{@props.id}/pelaajat" eventKey="players">Pelaajat</NavItem>
          </Nav>
          <div className="tab-content" ref="panes">
            <TabPane key="schedule" animation={false} active={activeKey is "schedule"}>
              <h1>Ottelut</h1>
              <TeamSchedule team={@props.team} />
            </TabPane>
            <TabPane key="stats" animation={false} active={activeKey is "stats"}>
              <h1>Tilastot</h1>
              <TeamStats teamId={@props.id} stats={@props.team.stats} />
            </TabPane>
            <TabPane key="players" animation={false} active={activeKey is "players"}>
              <h1>Pelaajat</h1>
              <TeamRoster teamId={@props.id} roster={@props.team.roster} />
            </TabPane>
          </div>
        </div>

      </div>
    </div>

module.exports = Team