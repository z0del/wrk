{-# LANGUAGE PartialTypeSignatures #-}
{-# OPTIONS_GHC -fno-warn-partial-type-signatures #-}
module MultiClockFifo where

import CLaSH.Prelude
import CLaSH.Prelude.Explicit
import Data.Maybe             (isJust)

fifoMem wclk rclk addrSize wfull raddr wdataM =
  asyncRam' wclk rclk
            (pow2SNat addrSize)
            raddr
            (mux (not <$> wfull)
                 wdataM
                 (pure Nothing))

ptrCompareT addrSize flagGen (bin,ptr,flag) (s_ptr,inc) =
    ((bin',ptr',flag')
    ,(flag,addr,ptr))
  where
    -- GRAYSTYLE2 pointer
    bin' = bin + boolToBV (inc && not flag)
    ptr' = (bin' `shiftR` 1) `xor` bin'
    addr = slice (addrSize `subSNat` d1) d0 bin

    flag' = flagGen ptr' s_ptr

-- FIFO empty: when next pntr == synchronized wptr or on reset
isEmpty       = (==)
rptrEmptyInit = (0,0,True)

-- FIFO full: when next pntr == synchonized {~wptr[addrSize:addrSize-1],wptr[addrSize-1:0]}
isFull addrSize ptr s_ptr =
    ptr == complement (slice addrSize (addrSize `subSNat` d1) s_ptr) ++#
                      slice (addrSize `subSNat` d2) d0  s_ptr

wptrFullInit        = (0,0,False)

-- Dual flip-flip synchroniser
ptrSync clk1 clk2 = register' clk2 0
                  . register' clk2 0
                  . unsafeSynchronizer clk1 clk2

-- Async FIFO synchroniser
fifo
  :: _
  => SNat (addrSize + 2)
  -> SClock wclk
  -> SClock rclk
  -> Signal' rclk Bool
  -> Signal' wclk (Maybe a)
  -> (Signal' rclk a, Signal' rclk Bool, Signal' wclk Bool)
fifo addrSize wclk rclk rinc wdataM = (rdata,rempty,wfull)
  where
    s_rptr = ptrSync rclk wclk rptr
    s_wptr = ptrSync wclk rclk wptr

    rdata = fifoMem wclk rclk addrSize wfull raddr
               (liftA2 (,) <$> (Just <$> waddr) <*> wdataM)

    (rempty,raddr,rptr) = mealyB' rclk (ptrCompareT addrSize isEmpty) rptrEmptyInit
                                  (s_wptr,rinc)

    (wfull,waddr,wptr)  = mealyB' wclk (ptrCompareT addrSize (isFull addrSize))
                                  wptrFullInit (s_rptr,isJust <$> wdataM)
