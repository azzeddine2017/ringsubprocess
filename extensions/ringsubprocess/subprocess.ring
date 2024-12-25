if iswindows()
loadlib("ring_subprocess.dll")
ok

Class ProcessManager {
    pObject
    
    func init
        pObject = subprocess_init()
    
    func runCommand command
        if not isnull(pObject) {
            return subprocess_create(pObject, command)
        }
        return 0
    
    func runCommandAsync command
        if not isnull(pObject) {
            return subprocess_execute(pObject, command)
        }
        return 0
    
    func waitForComplete
        if not isnull(pObject) {
            return subprocess_wait(pObject)
        }
        return 0
    
    func readOutput
        if not isnull(pObject) {
            return subprocess_getoutput(pObject)
        }
        return ""
    
    func kill
        if not isnull(pObject) {
            subprocess_terminate(pObject)
            pObject = NULL
        }
    
    func isActive
        if isnull(pObject) {
            return false
        }
        return true
    
    func setStdin data
        if not isnull(pObject) {
            return subprocess_setstdin(pObject, data)
        }
        return 0
    
    func getStderr
        if not isnull(pObject) {
            return subprocess_geterror(pObject)
        }
        return ""
    
    func getExitCode
        if not isnull(pObject) {
            return subprocess_getexitcode(pObject)
        }
        return -1
    
    func getPid
        if not isnull(pObject) {
            return subprocess_getpid(pObject)
        }
        return -1
    
    func readOutputAsync
        if not isnull(pObject) {
            return subprocess_readasync(pObject)
        }
        return ""
}
