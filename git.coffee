fs = require 'fs'

# Constantes

# adminRepositoryPath = '/home/gitadmin/gitolite-admin'


module.exports =

  adminRepositoryPath: 'gitolite-admin'
  keydirPath: "#{@adminRepositoryPath}/keydir"
  confPath: "#{@adminRepositoryPath}/conf"
  subconfPath: "#{@confPath}/subconf"

  # Repository Configuration Format
  repoConf: (repository, developers=undefined) ->
    if developers
      return repoConfWithDevelopers =
        """
          repo    #{repository}
            RW+     = guillaume
            RW      = #{developers.join(' ')}
        """
    else
      return repoConfWithoutDevelopers =
        """
          repo    #{repository}
            RW+     = guillaume
        """

  # Repository
  createRepository: (repository, next=->) ->
    fs.writeFile "#{@subconfPath}/#{repository}.subconf", @repoConf(repository), (err) ->
      console.log "repository #{repository} created"
      next()

  deleteRepository: (repository, next=->) ->
    fs.unlink "#{@subconfPath}/#{repository}.subconf", (err) ->
      console.log "repository #{repository} deleted"
      next()

  # Developer to Repository
  updateRepositoryDevelopers: (repository, developers, next=->) ->
    fs.writeFile "#{@subconfPath}/#{repository}.subconf", @repoConf(repository, developers), (err) ->
      console.log "repository #{repository} developpers permision updated"
      next()

  # SSH Key
  addDeveloperSshKey: (name, sshKey, next=->) ->
    fs.writeFile "#{@keydirPath}/#{name}.pub", sshKey, (err) ->
      console.log "ssh key #{name} added"
      next()

  deleteDeveloperSshKey: (name, next=->) ->
    fs.unlink "#{@keydirPath}/#{name}.pub", (err) ->
      console.log "ssh key #{name} deleted"
      next()


