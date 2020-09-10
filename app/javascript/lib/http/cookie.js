export function getCookieValue(cookieName) {
  const cookies = document.cookie ? document.cookie.split("; ") : []
  const cookie = cookies.find((cookie) => cookie.startsWith(cookieName))
  if (cookie) {
    const value = cookie.split("=").slice(1).join("=")
    return value ? decodeURIComponent(value) : undefined
  }
}
