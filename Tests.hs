{-# LANGUAGE OverloadedStrings #-}

module Main(main) where

import Prelude hiding ((.), id)

import Test.Hspec
import Test.QuickCheck
import Test.QuickCheck.Function

import Data.Monoid

import Data.Monoid.Idempotent
import Data.Monoid.Extrema

import Data.Int
import qualified Data.Set as Set
import qualified Data.IntSet as IntSet
import qualified Data.Map.Lazy as ML
import qualified Data.Map.Strict as MS
import qualified Data.IntMap.Lazy as IML
import qualified Data.IntMap.Strict as IMS

main :: IO ()
main = hspec $ do
  describe "unit" $ do
    it "satisfies the idempotence law" $ do
      () `mappend` () `shouldBe` ()

  describe "First" $ do
    it "satisfies the idempotence law" $ property $ do
      \x -> First x `mappend` First x `shouldBe` First (x :: Maybe Bool)

  describe "Last" $ do
    it "satisfies the idempotence law" $ property $ do
      \x -> Last x `mappend` Last x `shouldBe` Last (x :: Maybe Bool)

  describe "Any" $ do
    it "satisfies the idempotence law for False" $ do
      Any False `mappend` Any False `shouldBe` Any False

    it "satisfies the idempotence law for True" $ do
      Any True `mappend` Any True `shouldBe` Any True

  describe "All" $ do
    it "satisfies the idempotence law for False" $ do
      All False `mappend` All False `shouldBe` All False

    it "satisfies the idempotence law for True" $ do
      All True `mappend` All True `shouldBe` All True

  describe "Ordering" $ do
    it "satisfies the idempotence law for LT" $ do
      LT `mappend` LT `shouldBe` LT
    it "satisfies the idempotence law for EQ" $ do
      EQ `mappend` EQ `shouldBe` EQ
    it "satisfies the idempotence law for GT" $ do
      GT `mappend` GT `shouldBe` GT

  describe "functions" $ do
    it "satisy the idempotence law" $ property $ do
      \f x -> let f' = apply f in (f' `mappend` f') x `shouldBe` (f' (x :: Int) :: Ordering)

  describe "duals" $ do
    it "satisfy the idempotence law" $ property $ do
      \x -> Dual x `mappend` Dual x `shouldBe` Dual (x :: Ordering)

  describe "products" $ do
    describe "with two elements" $ do
      it "satisfy the idempotence law" $ property $ do
        \x y -> (x, y) `mappend` (x, y) `shouldBe` (x :: Ordering, y :: Ordering)

    describe "with three elements" $ do
      it "satisfy the idempotence law" $ property $ do
        \x y z -> (x, y, z) `mappend` (x, y, z) `shouldBe` (x :: Ordering, y :: Ordering, z :: Ordering)

    describe "with four elements" $ do
      it "satisfy the idempotence law" $ property $ do
        \x y z w -> (x, y, z, w) `mappend` (x, y, z, w) `shouldBe` (x :: Ordering, y :: Ordering, z :: Ordering, w :: Ordering)

    describe "with five elements" $ do
      it "satisfy the idempotence law" $ property $ do
        \x y z w v -> (x, y, z, w, v) `mappend` (x, y, z, w, v) `shouldBe` (x :: Ordering, y :: Ordering, z :: Ordering, w :: Ordering, v :: Ordering)

  describe "sets" $ do
    it "satisfies the idempotence law" $ property $ do
      \x' -> let x = Set.fromList x' in (x :: Set.Set Int) `mappend` x `shouldBe` x

  describe "IntSet" $ do
    it "satisfies the idempotence law" $ property $ do
      \x' -> let x = IntSet.fromList x' in x `mappend` x `shouldBe` x

  describe "lazy map" $ do
    it "satisfies the idempotence law" $ property $ do
      \x' -> let x = (ML.fromList x' :: ML.Map Integer String) in x `mappend` x `shouldBe` x

  describe "strict map" $ do
    it "satisfies the idempotence law" $ property $ do
      \x' -> let x = (MS.fromList x' :: MS.Map Integer String) in x `mappend` x `shouldBe` x

  describe "lazy int map" $ do
    it "satisfies the idempotence law" $ property $ do
      \x' -> let x = (IML.fromList x' :: IML.IntMap String) in x `mappend` x `shouldBe` x

  describe "strict int map" $ do
    it "satisfies the idempotence law" $ property $ do
      \x' -> let x = (IMS.fromList x' :: IMS.IntMap String) in x `mappend` x `shouldBe` x

  describe "Extrema" $ do
    describe "Min" $ do
      it "yields the minimum element" $ property $ do
        \x y -> Min x `mappend` Min y `shouldBe` Min (min x (y :: Int32))

      it "has a left-identity" $ property $ do
        \x -> Min x `mappend` mempty `shouldBe` Min (x :: Int32)

      it "has a right-identity" $ property $ do
        \x -> mempty `mappend` Min x `shouldBe` Min (x :: Int32)

      it "is associative" $ property $ do
        \x y z -> (Min x `mappend` Min y) `mappend` Min z `shouldBe` Min x `mappend` (Min y `mappend` Min (z :: Int32))

      it "is commutative" $ property $ do
        \x y -> (Min x `mappend` Min y) `shouldBe` (Min y `mappend` Min (x :: Int32))

      it "satisfies the idempotence law" $ property $ do
        \x -> Min x `mappend` Min x `shouldBe` Min (x :: Int32)

      it "is functionally identical to All for booleans" $ property $ do
        \x y -> getMin (Min x `mappend` Min y) `shouldBe` getAll (All x `mappend` All y)

    describe "Max" $ do
      it "yields the maximum element" $ property $ do
        \x y -> Max x `mappend` Max y `shouldBe` Max (max x (y :: Int32))

      it "has a left-identity" $ property $ do
        \x -> Max x `mappend` mempty `shouldBe` Max (x :: Int32)

      it "has a right-identity" $ property $ do
        \x -> mempty `mappend` Max x `shouldBe` Max (x :: Int32)

      it "is associative" $ property $ do
        \x y z -> (Max x `mappend` Max y) `mappend` Max z `shouldBe` Max x `mappend` (Max y `mappend` Max (z :: Int32))

      it "is commutative" $ property $ do
        \x y -> (Max x `mappend` Max y) `shouldBe` (Max y `mappend` Max (x :: Int32))

      it "satisfies the idempotence law" $ property $ do
        \x -> Max x `mappend` Max x `shouldBe` Max (x :: Int32)

      it "is functionally identical to Any for booleans" $ property $ do
        \x y -> getMax (Max x `mappend` Max y) `shouldBe` getAny (Any x `mappend` Any y)

