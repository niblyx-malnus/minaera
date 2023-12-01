/-  *minaera, feed
/+  n=nectar, sss, bout, verb, dbug, default-agent
::  minAera
::
::  holds database of tables,
::  holds sss publications over each table,
::  
|%
::  `graph` is a map keyed by [app feed]. 
::     - `app` is the source of information getting submitted.
::     - `feed` is the name of the agent submitting to the graph
::
+$  state-0   [%0 graph=database:n]
+$  versioned-state
  $%  state-0
  ==
::
+$  card      card:agent:gall
::
++  sub-feed  (mk-subs:sss feed ,[%feed %minaera @ @ ~])
++  pub-feed  (mk-pubs:sss feed ,[%feed %minaera @ @ ~]) 
::
++  da-feed
  |=  [sf=_sub-feed =bowl:gall]
  =/  da  (da:sss feed ,[%feed %minaera @ @ ~])
  %-  da
  :*  sf
      bowl
      -:!>(*result:da)
      -:!>(*from:da)
      -:!>(*fail:da)
  ==
::
++  du-feed
  |=  [pf=_pub-feed =bowl:gall]
  =/  du  (du:sss feed ,[%feed %minaera @ @ ~])
  (du pf bowl -:!>(*result:du))
--
::
%+  verb  &
%-  agent:bout
%-  agent:dbug
=|  state=state-0
=/  sf  sub-feed
=/  pf  pub-feed
::
=<
::
^-  agent:gall
|_  =bowl:gall
+*  this  .
    def   ~(. (default-agent this %|) bowl)
    daf   (da-feed sf bowl)
    duf   (du-feed pf bowl)
    hc    ~(. +> bowl)
::
++  on-save   !>([state pf sf])
::
++  on-load
  |=  =vase
  ^-  (quip card _this)
  =+  !<(old=[state-0 =_pf =_sf] vase)
  :-  ~
  %=  this
    pf     pf.old
    sf     sf.old
    state  -.old
  ==
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ?+    mark  !!
      %aera-action
    =/  act  !<(aera-action vase)
    =/  [cards=(list card) pf=_pf sf=_sf state=_state]
      (handle-aera-action:hc act)
    [cards this(sf sf, pf pf, state state)]
    ::
      %surf-feed
    =^  cards  sf
      %+  surf:daf
        !<(@p (slot 2 vase))
      minaera+!<([%feed %minaera @ @ ~] (slot 3 vase))
    [cards this]
    ::
      %sss-on-rock
    `this
    ::
      %sss-fake-on-rock
    :_  this
    ?-  msg=!<(from:daf (fled:sss vase))
      [[%feed *] *]  (handle-fake-on-rock:daf msg)
    ==
    ::
      %sss-to-pub
    ?-    msg=!<(into:duf (fled:sss vase))
        [[%feed %minaera *] *]
      =^  cards  pf  (apply:duf msg)
      [cards this]
    ==
    ::
      %sss-feed
    =/  res  !<(into:daf (fled:sss vase))
    =^  cards  sf  (apply:daf res)
    [cards this]
  ==
:: Manage incoming information related to solid state subscriptions...
::
++  on-agent
  |=  [=wire sign=sign:agent:gall]
  ^-  (quip card _this)
  ::
  ?.  =(%poke-ack -.sign)
    (on-agent:def wire sign)
  ::
  ?+    wire  (on-agent:def wire sign)
      [~ %sss %on-rock @ @ @ %feed %minaera @ @ ~]
    `this(sf (chit:daf |3:wire sign))
  ::
      [~ %sss %scry-request @ @ @ %feed %minaera @ @ ~]
    =^  cards  sf  (tell:daf |3:wire sign)
    [cards this]
  ::
      [~ %sss %scry-response @ @ @ %feed %minaera @ @ ~]
    =^  cards  pf  (tell:duf |3:wire sign)
    [cards this]
  ==
::
++  on-watch
  |=  path=path
  ^-  (quip card _this)
  `this
::
++  on-init   on-init:def
++  on-leave  on-leave:def
++  on-peek   on-peek:def 
++  on-arvo   on-arvo:def
++  on-fail   on-fail:def
--
::
|_  =bowl:gall
+*  this  .
    daf   (da-feed sf bowl)
    duf   (du-feed pf bowl)
::
++  handle-aera-action
  |=  act=aera-action
  ^-  (quip card _[pf sf state])
  ?-    -.act
      %init-table
    ?:  (~(has by graph.state) [app.act feed.act])
      ~|("%minaera: table [{<app.act>} {<feed.act>}] already exists" !!)
    ::
    =.  graph.state  (nectar-add-table graph.state [feed app]:act)
    ::
    =^  cards  pf
      (give:duf [%feed %minaera app.act feed.act ~] [%init nectar-new-table])
    [cards pf sf state]
    ::
      %add-edge
    ?.  (~(has by graph.state) [app.act feed.act])
      ~|("%minaera: no table  [{<app.act>} {<feed.act>}]" !!)
    ::
    =.  graph.state  (nectar-insert graph.state [aera-row feed app]:act)
    ::
    =^  cards  pf
      (give:duf [%feed %minaera app.act feed.act ~] [%add ~[aera-row.act]])
    [cards pf sf state]
  ::
    %del-edge
    ?.  (~(has by graph.state) [app.act feed.act])
      ~|("%minaera: no table  [{<app.act>} {<feed.act>}]" !!)
    ::
    =.  graph.state  (nectar-delete graph.state [id feed app]:act)
    ::
    =^  cards  pf
      (give:duf [%feed %minaera app.act feed.act ~] [%del id.act])
    [cards pf sf state]
  ==
::
++  nectar-new-table
  ^-  table:n
  :*  schema=(make-schema:n aera-schema)
      primary-key=~[%id]
      indices=(make-indices:n [~[%id] pr=& ai=~ uq=& cs=|]~)
      records=~
  ==
::
++  nectar-add-table
  |=  [graph=database:n feed=@ =app:n]
  ^-  database:n
  =<  +
  %+  ~(q db:n graph)
    app
  [%add-table feed nectar-new-table]
::
++  nectar-insert
  |=  [graph=database:n =aera-row feed=@ =app:n]
  ^-  database:n
  =<  +
  %+  ~(q db:n graph)
    app
  [%insert feed ~[aera-row]]
::
++  nectar-delete
  |=  [graph=database:n id=@ feed=@ =app:n]
  ^-  database:n
  =<  +
  %+  ~(q db:n graph)
    app
  [%delete feed [%s %id [%.y [%eq id]]]]
--