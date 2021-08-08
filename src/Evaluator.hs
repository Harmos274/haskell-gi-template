{-# LANGUAGE OverloadedStrings, OverloadedLabels #-}

module Evaluator
  (eval
  ) where

import Parser (Window (..), Layout (..), Label (..), Widget (..))

import qualified GI.Gtk as Gtk
import Data.GI.Base
import Data.Text (pack)


eval :: Window -> IO ()
eval (Window (Label label) lyt) = do
  win <- new Gtk.Window [ #title := pack label ]
  on win #destroy Gtk.mainQuit

  base_box <- new Gtk.Box [ #orientation := Gtk.OrientationVertical ]

  populateWindow base_box lyt
  
  #add win base_box

  #showAll win
  return ()


populateWindow :: Gtk.Box -> Maybe Layout -> IO ()
populateWindow box Nothing                 = return ()
populateWindow box (Just (Vertical verts)) = mapM_ (populateWindowLine box) verts
populateWindow _   _                       = error "Top level layout is supposed to be vertical."

populateWindowLine :: Gtk.Box -> Layout -> IO ()
populateWindowLine box (Horizontal horz) = new Gtk.Box [#orientation := Gtk.OrientationHorizontal] >>= populateWindowLine' box horz
populateWindowLine _   _                 = error "Rows needs an Horizontal layout."

populateWindowLine' :: Gtk.Box -> [Layout] -> Gtk.Box -> IO ()
populateWindowLine' box horz h_box = mapM_ (populateWindowRow h_box) horz >> #add box h_box

populateWindowRow :: Gtk.Box -> Layout -> IO ()
populateWindowRow box (Unit (Button (Label label)))   = new Gtk.Button      [ #label := pack label ] >>= #add box
populateWindowRow box (Unit (CheckBox (Label label))) = new Gtk.CheckButton [ #label := pack label ] >>= #add box
populateWindowRow box (Unit (Text (Label label)))     = new Gtk.Label       [ #label := pack label ] >>= #add box
populateWindowRow _   _                               = error "Rows can only be populated by widgets."
