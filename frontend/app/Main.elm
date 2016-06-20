port module Main exposing (main)

import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Html.Attributes.Extra exposing (..)
import Html.Events exposing (onClick)
import Platform.Cmd
import Json.Decode as JD
import Json.Encode as JE
import Debug exposing (log)


{---- Model ----}


type alias Model =
    { things : List Thing
    , selected : String
    , page : String
    , stats : Stats
    }


type alias Stats =
    { total : Int
    , things : List ( String, Int )
    }


type alias Thing =
    { uuid : String
    , name : String
    , text : String
    }


type alias ThingEvent =
    { uuid : String
    , state :
        String
        --, type : String
    , typ : String
    }


emptyThing : Thing
emptyThing =
    { uuid = ""
    , name = ""
    , text = ""
    }


init : Stats -> ( Model, Cmd Msg )
init stats =
    ( { things = []
      , selected = ""
      , page = "start"
      , stats = stats
      }
    , Cmd.none
    )


db : List Thing
db =
    [ { uuid = "d0d3fa86ca7645ec9bd96af4ab074a13dee28fa2", name = "Smartphone", text = "Früher brauchten die Menschen Karten, Kompass, Taschenlampen, etc.,<br>um sich zurecht zu finden, ein Radio, um sich informieren zu können,<br>Fotos und Kamera, um sich zu erinnern und Momente festzuhalten.<br>Heutzutage vereint das Handy all diese Funktionen in einem Gerät." }
    , { uuid = "d0d3fa86ca7645ec9bd96af4bce68b06afdac14d", name = "Geld", text = "Geld, Geld, Geld. Geld regiert die Welt.<br>Doch damals, als die Manns geflohen sind, gab es viele verschiedene Währungen, die es schwierig machten, mit Geld zu bezahlen und den Wert zu vergleichen" }
    , { uuid = "d0d3fa86ca7645ec9bd96af44c435b5e89ebccb3", name = "Essen", text = "Was würdest du eher mitnehmen: deine Lieblingssüßigkeit oder etwas Nahrhaftes?" }
    , { uuid = "d0d3fa86ca7645ec9bd96af4960edabbf5e494b8", name = "Kleidung", text = "Manch einer nimmt die Multifunktionsjacke und die Wanderschuhe mit,<br>andere retten ihre feine Garderobe<br>So auch Thomas Mann: Er nahm seine Pelze mit." }
    , { uuid = "d0d3fa86ca7645ec9bd96af4509d21d91f7094f5", name = "Erinnerungen", text = "Ganz spontan:<br>Welches ist dein liebstes Erinnerungsstück?<br>Würdest du dafür etwas Wichtiges zurücklassen?" }
    , { uuid = "d0d3fa86ca7645ec9bd96af45769d4c469ba653a", name = "Hygieneartikel", text = "Heutzutage verbieten die Schlepper den Flüchtlingen,<br>für uns selbstverständliches Gepäck auf die Boote mitzunehmen,<br>da es den Platz für eine weitere Person einnehmen würde." }
    , { uuid = "d0d3fa86ca7645ec9bd96af4d62d3ca7158a442d", name = "Taschenmesser", text = "Ein wahres Allzweckgerät:<br>Man kann es als Messer, Säge, Korkenzieher, Flaschen-/Dosenöffner, Zahnstocher, Löffel, Gabel, Nagelfeile und Schere benutzen." }
    , { uuid = "d0d3fa86ca7645ec9bd96af4603572638582630c", name = "Schlafsack", text = "Zelt, Schlafsack, Decken, Kissen - „ein provisorisches Haus“" }
    , { uuid = "d0d3fa86ca7645ec9bd96af498b71962fe2e3db2", name = "Streichhölzer", text = "Feuer wärmt in kalten Nächten, die man unter freiem Himmel verbringen muss." }
    , { uuid = "d0d3fa86ca7645ec9bd96af48ac10846ff929569", name = "Reisepass", text = "1936 wird auch den letzten Mitgliedern der Familie Mann die deutsche Staatsbürgerschaft aberkannt." }
    , { uuid = "d0d3fa86ca7645ec9bd96af4d927ca5fe7f3eb3f", name = "Kuscheltier", text = "Was ist für dich Geborgenheit?" }
    , { uuid = "d0d3fa86ca7645ec9bd96af4f8998ec2a73ab148", name = "Waffe", text = "In der Fremde ist alles ungewohnt und angsteinflößend.<br>Bietet eine Waffe wirklich Sicherheit?" }
    , { uuid = "d0d3fa86ca7645ec9bd96af42e7a03b23a6f759b", name = "Medizin", text = "Welche Medikamente brauchst du?<br>Was würde passieren, wenn du sie nicht nehmen würdest?" }
    , { uuid = "d0d3fa86ca7645ec9bd96af4373321577515cb0a", name = "Bücher", text = "Ein Buch, zwei Bücher, drei Bücher...<br>Thomas Mann nahm viele seiner Bücher mit.<br>Egal wohin er ging, er ließ sich seinen Bücherschrank und seinen Schreibtisch immer hinterher schicken." }
    , { uuid = "d0d3fa86ca7645ec9bd96af4a08f70900d461cc9", name = "Spiele", text = "Ist dir Gesellschaft beim Spielen wichtig?" }
    , { uuid = "d0d3fa86ca7645ec9bd96af4c954ddc024288aca", name = "Notfallset", text = "Nicht alle Wege sind eben.<br>Leicht hätte sich auch Heinrich Mann verletzen können,<br>als er über die Pyrenäen fliehen musste." }
    , { uuid = "d0d3fa86ca7645ec9bd96af443f18f2fb25c2566", name = "Musik", text = "Musik?<br>Nee, für Erika war das Theater das Wichtigste in ihrem Leben.<br>Auch ein Teil ihrer Theatergruppe „Die Pfeffermühle“ folgte ihr ins Exil." }
    , { uuid = "d0d3fa86ca7645ec9bd96af4acc3117cd2264bf3", name = "Karte", text = "Mit Hilfe einer Karte würde man sich in einem fremden Land besser zurechtfinden.<br>Aber kann sie einem auch den Weg weisen, wenn man nicht so genau weiß,<br>wo das endgültige Ziel ist?" }
    , { uuid = "d0d3fa86ca7645ec9bd96af421cd478197c9638b", name = "Taschenlampe", text = "Licht erhellt die dunklen Ecken und kann die Angst vertreiben." }
    , { uuid = "d0d3fa86ca7645ec9bd96af4ed896fad3d785489", name = "Seil", text = "Ein Seil kann recht praktisch sein:<br>Um sich aneinander zu binden und sich nicht zu verlieren und<br>um Kleidung darüber zu hängen, damit sie trocknet.<br>Aber braucht man es wirklich, um die Flucht zu überleben?" }
    ]


getThing : String -> Maybe Thing
getThing uuid =
    List.head (List.filter (\t -> uuid == t.uuid) db)



{---- Update ----}


type Msg
    = NoOp
    | Start
    | Submit
    | SetStats Stats
    | ShowStats
    | Add String
    | Remove String
    | Show String
    | ThingHappens ThingEvent


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case (log "msg" msg) of
        {- pages TODO: use routing -}
        Start ->
            ( { model
                | page =
                    if List.isEmpty model.things then
                        "start"
                    else
                        "suitcase"
              }
            , Cmd.none
            )

        Submit ->
            if List.length model.things > 5 then
                ( model, Cmd.none )
            else
                let
                    stats =
                        nextStats model.stats <| List.map (\t -> t.uuid) model.things
                in
                    ( { model
                        | page = "end"
                        , stats = stats
                      }
                    , saveStats stats
                    )

        SetStats stats ->
            ( { model | stats = stats }, Cmd.none )

        ShowStats ->
            ( { model | page = "end" }, Cmd.none )

        {- thing handling -}
        ThingHappens event ->
            -- That's probably not how it's intended to be done..
            update
                (case event.typ of
                    "thing" ->
                        if event.state == "IN" then
                            Add event.uuid
                        else
                            Remove event.uuid

                    "lid" ->
                        if event.state == "OPEN" then
                            Start
                        else
                            Submit

                    _ ->
                        NoOp
                )
                model

        Add uuid ->
            if List.any (\t -> t.uuid == uuid) model.things then
                ( { model
                    | page = "suitcase"
                  }
                , Cmd.none
                )
            else
                case getThing uuid of
                    Just t ->
                        ( { model
                            | selected = uuid
                            , things = model.things ++ [ t ]
                            , page =
                                if model.page /= "end" then
                                    "suitcase"
                                else
                                    model.page
                          }
                        , Cmd.none
                        )

                    Nothing ->
                        ( model, Cmd.none )

        Remove uuid ->
            let
                things =
                    List.filter (\t -> t.uuid /= uuid) model.things

                page =
                    if List.length things == 0 then
                        "start"
                    else
                        model.page
            in
                ( { model
                    | page = page
                    , things = things
                    , selected =
                        if model.selected == uuid then
                            .uuid (Maybe.withDefault { uuid = "", name = "", text = "" } (List.head things))
                        else
                            model.selected
                  }
                , Cmd.none
                )

        Show uuid ->
            ( { model | selected = uuid }, Cmd.none )

        NoOp ->
            ( model, Cmd.none )



{---- View ----}


view : Model -> Html Msg
view model =
    div []
        [ div [ class "icons" ] []
        , case model.page of
            "start" ->
                pageStart model

            "suitcase" ->
                pageSuitcase model

            "end" ->
                pageEnd model

            _ ->
                span [] [ text ("unknown page: " ++ model.page) ]
        ]


pageStart : Model -> Html Msg
pageStart model =
    hero []
        [ h1 [ class "title" ] [ text "Willkommen zum Kofferpacken" ]
        , div [ class "content" ]
            [ p []
                [ text "Stell dir vor, du müsstest ins Exil."
                , br [] []
                , text "Packe die Gegenstände vom Tisch, die du mitnehmen würdest, in den Koffer."
                , br [] []
                , text "Du kannst maximal fünf Gegenstände mitnehmen."
                , br [] []
                , text "Schließe den Deckel zur Abreise."
                ]
            ]
        ]
        []


pageSuitcase : Model -> Html Msg
pageSuitcase model =
    hero []
        [ header
            [ span
                [ class
                    <| "counter"
                    ++ if List.length model.things > 5 then
                        " is-danger"
                       else
                        ""
                ]
                [ text <| padInt <| List.length model.things ]
            , span [ class "counter-text" ] [ text "von 05" ]
            , span [ class "subtitle" ] [ text "Gegenständen im Koffer:" ]
            ]
            [ a
                [ onClick Submit
                , class
                    <| "button is-medium arrow-after arrow-small"
                    ++ if List.length model.things > 5 then
                        " is-disabled"
                       else
                        ""
                ]
                [ text "zur Auswertung" ]
            ]
        , selectedThingBox
            <| Maybe.withDefault emptyThing
            <| List.head
            <| List.filter (\t -> t.uuid == model.selected) model.things
        ]
        [ div [ class "icon-suitcase" ] []
        , div [ class "thing-select" ]
            <| List.map
                (\t ->
                    a
                        [ onClick <| Show t.uuid
                        , class
                            <| "button is-medium"
                            ++ if t.uuid == model.selected then
                                " is-active"
                               else
                                ""
                        ]
                        [ text t.name ]
                )
                model.things
        ]


pageEnd : Model -> Html Msg
pageEnd model =
    hero []
        [ header
            [ h1 [ class "subtitle" ] [ text """
        Hier kannst Du sehen, wie oft die jeweiligen Gegenstände mitgenommen wurden:
      """ ]
            ]
            []
        , div [ class "icon-suitcase page-end" ] []
        , div [ class "stats" ]
            <| List.map (statRow model.stats)
                model.things
        , a
            [ onClick Start
            , class "button is-large arrow-before arrow-big"
            ]
            [ text "Zurück zum Start" ]
        ]
        []


statRow : Stats -> Thing -> Html Msg
statRow stats thing =
    let
        count =
            List.filter (\entry -> thing.uuid == (fst entry)) stats.things
                |> List.head
                |> Maybe.withDefault ( "", 1 )
                |> snd

        percent =
            round <| (count * 100) / (toFloat stats.total)

        percentStr =
            (toString percent) ++ "%"

        labelStr =
            (padInt count) ++ " Mal = " ++ (toString percent) ++ "%"

        barContent =
            if percent > 75 then
                [ div [ style [ ( "width", percentStr ) ] ]
                    [ span [ class "label" ] [ text labelStr ]
                    ]
                ]
            else
                [ div [ style [ ( "width", percentStr ) ] ] []
                , span [ class "label" ] [ text labelStr ]
                ]
    in
        div [ class "columns" ]
            [ div [ class "column name-box" ]
                [ div [ class "name" ] [ text thing.name ]
                ]
            , div [ class "column" ]
                [ div [ class "percent is-clearfix" ] barContent
                ]
            ]


selectedThingBox : Thing -> Html Msg
selectedThingBox thing =
    div [ class "thing-box" ]
        [ h1 [ class "title" ] [ text thing.name ]
        , div [ class "content" ]
            [ p [ innerHtml thing.text ] []
            ]
        ]


hero : List (Html Msg) -> List (Html Msg) -> List (Html Msg) -> Html Msg
hero h c f =
    let
        header =
            if List.isEmpty h then
                []
            else
                [ div [ class "hero-header" ] h ]

        content =
            if List.isEmpty c then
                []
            else
                [ div [ class "hero-content" ]
                    [ div [ class "container" ] c
                    ]
                ]

        footer =
            if List.isEmpty f then
                []
            else
                [ div [ class "hero-footer" ]
                    [ div [ class "container" ] f
                    ]
                ]

        children =
            List.foldr
                (\el ch ->
                    if List.isEmpty el then
                        ch
                    else
                        el ++ ch
                )
                []
                [ header, content, footer ]
    in
        section [ class "hero is-fullheight is-bbh is-bold" ] children


header : List (Html Msg) -> List (Html Msg) -> Html Msg
header left right =
    div [ class "header" ]
        [ div [ class "container" ]
            [ div [ class "header-left" ]
                [ span [ class "header-item" ] left
                ]
            , div [ class "header-right" ]
                [ span [ class "header-item" ] right
                ]
            ]
        ]



{---- Main ----}


main : Program Stats
main =
    App.programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> thingHappens ThingHappens
        }



{---- JS ports ----}
-- incomming


port thingHappens : (ThingEvent -> msg) -> Sub msg



-- outgoing


port saveStats : Stats -> Cmd msg



{---- Helpers ----}


nextStats : Stats -> List String -> Stats
nextStats stats uuids =
    { stats
        | total = stats.total + 1
        , things =
            List.foldr
                (\uuid things ->
                    let
                        existing =
                            List.head <| List.filter (\t -> (fst t) == uuid) things

                        entry =
                            case existing of
                                Nothing ->
                                    ( uuid, 1 )

                                Just e ->
                                    ( uuid, (snd e) + 1 )
                    in
                        entry :: things
                )
                stats.things
                uuids
    }


padInt : Int -> String
padInt int =
    if int < 10 then
        "0" ++ (toString int)
    else
        toString int
