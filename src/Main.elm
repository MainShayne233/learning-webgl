module Main exposing (Model, Msg(..), Section, init, main, update, view)

import Browser
import GettingStartedWithWebGL
import Html exposing (Html, a, div, h1, h2, img, li, p, text, ul)
import Html.Attributes exposing (href, src, target)
import Html.Events exposing (onClick)



---- MODEL ----


type alias Section =
    { name : String, tutorialUrl : String }


type Page
    = SectionPage Section
    | Home


type alias Model =
    { sections : List Section, currentPage : Page }


sections : List Section
sections =
    [ Section "Getting started with WebGL" "https://developer.mozilla.org/en-US/docs/Web/API/WebGL_API/Tutorial/Getting_started_with_WebGL" ]


init : ( Model, Cmd Msg )
init =
    ( { sections = sections
      , currentPage = Home
      }
    , Cmd.none
    )



---- UPDATE ----


type Msg
    = NoOp
    | SetPage Page


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetPage page ->
            ( { model | currentPage = page }, Cmd.none )

        NoOp ->
            ( model, Cmd.none )



---- VIEW ----


renderSectionHeader section =
    div []
        [ h1 [] [ text section.name ]
        , p [] [ a [ href section.tutorialUrl, target "_blank" ] [ text "From this tutorial" ] ]
        , p [] [ a [ href "#", onClick (SetPage Home) ] [ text "Go Back" ] ]
        ]


renderSection section =
    let
        sectionToRender =
            case section.name of
                _ ->
                    GettingStartedWithWebGL.render
    in
    div []
        [ renderSectionHeader section
        , sectionToRender
        ]


renderSectionListItem section =
    li []
        [ a [ href "#", onClick (SetPage (SectionPage section)) ] [ text section.name ]
        ]


renderIndex all_sections =
    div []
        [ img [ src "/logo.svg" ] []
        , ul [] (List.map renderSectionListItem all_sections)
        ]


view : Model -> Html Msg
view model =
    case model.currentPage of
        Home ->
            renderIndex model.sections

        SectionPage section ->
            renderSection section



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
