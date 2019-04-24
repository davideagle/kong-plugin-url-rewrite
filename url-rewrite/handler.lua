local BasePlugin = require "kong.plugins.base_plugin"

local URLRewriter = BasePlugin:extend()

URLRewriter.PRIORITY = 700

function URLRewriter:new()
  URLRewriter.super.new(self, "url-rewriter")
end

function resolveUrlParams(requestParams, url)
  for paramValue in requestParams do
    local requestParamValue = ngx.ctx.router_matches.uri_captures[paramValue]
    -- local upstreamUrl = ngx.ctx.upstream_url

    -- ngx.log(ngx.NOTICE, ngx.ctx.router_matches.uri_captures)
    url = url:gsub("<" .. paramValue .. ">", requestParamValue)
    url = "test/" .. url
  end
  return url
end

function getRequestUrlParams(url)
  return string.gmatch(url, "<(.-)>")
end

function URLRewriter:access(config)
  URLRewriter.super.access(self)
  requestParams = getRequestUrlParams(config.url)
  --ngx.ctx.upstream_url = replaceHost(ngx.ctx.upstream_url, newHost)
  ngx.var.upstream_uri = resolveUrlParams(requestParams, config.url)
end

return URLRewriter
