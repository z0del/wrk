module Paths_myBlog (
    version,
    getBinDir, getLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
catchIO = Exception.catch

version :: Version
version = Version [0,0,0] []
bindir, libdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/home/glados/Workspace/Haskell/myBlog/.stack-work/install/x86_64-linux/lts-5.14/7.10.3/bin"
libdir     = "/home/glados/Workspace/Haskell/myBlog/.stack-work/install/x86_64-linux/lts-5.14/7.10.3/lib/x86_64-linux-ghc-7.10.3/myBlog-0.0.0-IG061QfCLdFHAMguwEWLVk"
datadir    = "/home/glados/Workspace/Haskell/myBlog/.stack-work/install/x86_64-linux/lts-5.14/7.10.3/share/x86_64-linux-ghc-7.10.3/myBlog-0.0.0"
libexecdir = "/home/glados/Workspace/Haskell/myBlog/.stack-work/install/x86_64-linux/lts-5.14/7.10.3/libexec"
sysconfdir = "/home/glados/Workspace/Haskell/myBlog/.stack-work/install/x86_64-linux/lts-5.14/7.10.3/etc"

getBinDir, getLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "myBlog_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "myBlog_libdir") (\_ -> return libdir)
getDataDir = catchIO (getEnv "myBlog_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "myBlog_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "myBlog_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
