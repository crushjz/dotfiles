require('gitlinker').setup {
  callbacks = {
    ['gitlab.qonto.co'] = require('gitlinker.hosts').get_gitlab_type_url,
  },
}
