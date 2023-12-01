::  A local feed ingestion engine
::
::  Ingests local groups events, sanitizes them, and submits them to %minaera graph
::
::  +on-agent arm listens for reacts to posts
::
/-  *minaera, chat
/+  bout, verb, dbug, default-agent
|%
++  event-version  0
+$  state-0  %0
+$  versioned-state
  $%  state-0
  ==
::
++  chat-subscribe-card
  |=  =ship
  [%pass /chat/updates %agent [ship %chat] %watch /ui]
::
++  minaera-init-card
|=  =ship
[%pass /minaera/action %agent [ship %minaera] %poke %aera-action !>([%init-table %groups %alfie])]
::
+$  card  card:agent:gall
--
::
%+  verb  &
%-  agent:bout
%-  agent:dbug
=|  state=state-0
::
^-  agent:gall
::
|_  =bowl:gall
+*  this  .
    def  ~(. (default-agent this %|) bowl)
::
++  on-init
  ^-  (quip card _this)
  :_  this
  ~[(chat-subscribe-card our.bowl) (minaera-init-card our.bowl)]
::
++  on-save   !>(state)
::
++  on-load
  |=  old=vase
  ^-  (quip card _this)
  =.  state  !<(state-0 old)
  `this
::
++  on-agent
  |=  [=wire =sign:agent:gall]
  ^-  (quip card _this)
  ?+  wire  (on-agent:def wire sign)
      [%chat %updates ~]
    ?+    -.sign  (on-agent:def wire sign)
      %watch-ack  `this
        %kick
      :_  this
      ~[(chat-subscribe-card our.bowl)]
    ::
        %fact
      ?+    p.cage.sign  `this
          %chat-action-0
        =/  =action:chat  !<(action:chat q.cage.sign)
        ?>  ?=([%writs *] q.q.action)
        =/  target=[to=@p post=@da]  p.p.q.q.action
        =/  =delta:writs:chat  q.p.q.q.action
        ~&  >  target
        ~&  >  delta
        ?:  =(our.bowl to.target)
          `this
        ::
        ::  If we aren't the one sending the react, ignore.
        ?+    delta  !!
            [%add-feel *]
          :_  this
          ?:  !=(our.bowl p.delta)
            ~
          =-  :~  :*  %pass  /minaera/action  %agent
                      [our.bowl %minaera]  %poke
                      %aera-action  !>([%add-edge %groups dap.bowl ar])
              ==  ==
          ^=  ar
          ^-  aera-row
          :*  id=`@`post.target 
              timestamp=p.q.action
              from=our.bowl
              to=to.target 
              what=q.delta 
              tag=%react
              description='Emoji react from %talk'
              app-tag=%chat-action-0
              event-version=%0
              ~
          ==
          ::
            [%del-feel *]
          :_  this
          ?:  !=(our.bowl p.delta)
            ~
          :~  :*  %pass  /minaera/action
                  %agent  [our.bowl %minaera]
                  %poke  %aera-action  !>(`aera-action`[%del-edge %groups dap.bowl post.target])
          ==  ==
        ==
      ==
    ==
  ==
::
++  on-poke   |=(=cage `this)
++  on-peek   |=(=path ~)
++  on-watch  |=(=path `this)
++  on-arvo   |=([=wire sign=sign-arvo] `this)
::
++  on-leave  on-leave:def
++  on-fail   on-fail:def
--